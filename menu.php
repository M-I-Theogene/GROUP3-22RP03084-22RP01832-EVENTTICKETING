<?php
require_once 'Util.php';
require_once 'Sms.php';
require_once 'Momo.php';

class Menu {
    protected $text;
    protected $sessionId;
    protected $phone;
    protected $pdo;
    protected $sms;
    protected $user;

    public function __construct($text, $sessionId, $phone) {
        $this->text      = trim($text, "*");
        $this->sessionId = $sessionId;
        $this->phone     = $phone;
        $this->pdo       = (new Util())->getConnection();
        $this->sms       = new Sms();

        $this->storeSession();
        $this->loadUser();
        $this->ensureRegistration();
    }

    private function storeSession() {
        $sql = "INSERT INTO sessions(session_id, phone_number, menu_state)
                VALUES(?,?,?)
                ON DUPLICATE KEY UPDATE menu_state = ?";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([
            $this->sessionId,
            $this->phone,
            $this->text,
            $this->text
        ]);
    }

    private function loadUser() {
        $stmt = $this->pdo->prepare("SELECT * FROM users WHERE phone_number = ?");
        $stmt->execute([$this->phone]);
        $this->user = $stmt->fetch(PDO::FETCH_ASSOC);
    }

    private function ensureRegistration() {
        $parts = explode("*", $this->text);
        $lvl   = count($parts);

        if (!$this->user) {
            $this->pdo->prepare("INSERT INTO users (phone_number, balance, role) VALUES (?, ?, 'user')") 
                      ->execute([$this->phone, Util::USER_INITIAL_BALANCE]);
            $this->loadUser();
        }

        if (empty($this->user['full_name'])) {
            if ($lvl === 1 && $parts[0] !== "") {
                $name = Util::sanitizeInput($parts[0]);
                $this->pdo->prepare("UPDATE users SET full_name = ? WHERE phone_number = ?")
                          ->execute([$name, $this->phone]);
                $this->user['full_name'] = $name;
                $this->con("Thank you, $name!\nCreate a 4‑digit PIN:");
                exit;
            }
            $this->con("Welcome to EventMint!\nPlease enter your full name:");
            exit;
        }

        if (empty($this->user['pin_hash'])) {
            if ($lvl >= 2) {
                $pin = $parts[1];
                if (!preg_match('/^\d{4}$/', $pin)) {
                    $this->end("PIN must be exactly 4 digits.");
                }
                $pinHash = password_hash($pin, PASSWORD_DEFAULT);
                $this->pdo->prepare("UPDATE users SET pin_hash = ? WHERE phone_number = ?")
                          ->execute([$pinHash, $this->phone]);
                $this->user['pin_hash'] = $pinHash;
                $this->sms->sendSMS(
                    "Welcome, {$this->user['full_name']}! Registration complete.",
                    $this->phone
                );
                $this->end("Registration complete! You can now purchase tickets.");
            }
            $this->con("Create a 4‑digit PIN:");
            exit;
        }
    }

    private function con($msg) {
        echo str_starts_with($msg, "CON") ? $msg : "CON $msg";
    }

    private function end($msg) {
        echo str_starts_with($msg, "END") ? $msg : "END $msg";
        exit;
    }

    public function middleware($inputText) {
        if ($inputText === "") return "";
        $parts = explode("*", $inputText);
        while (($i = array_search(Util::GO_BACK, $parts)) !== false) {
            array_splice($parts, $i - 1, 2);
        }
        if (($i = array_search(Util::GO_TO_MAIN_MENU, $parts)) !== false) {
            $parts = array_slice($parts, $i + 1);
        }
        return implode("*", $parts);
    }

    private function isOrganizer() {
        return $this->user['role'] === 'organizer';
    }

    public function mainMenu() {
        $this->con("Main Menu:\n1. Event Services\n2. MOMO Services\n3. Support");
    }

    public function flowEventServices($a) {
        $lvl   = count($a);
        $isOrg = $this->isOrganizer();

        if ($lvl === 1) {
            $menu = "Event Services:\n1. Buy Ticket\n2. View Events\n";
            $menu .= $isOrg ? "3. Organizer Menu\n" : "3. Register as Organizer\n";
            $menu .= Util::GO_BACK . ". Back";
            return $this->con($menu);
        }

        if ($lvl === 2 && $a[1] === '1') {
            $rows = $this->pdo->query(
                "SELECT id,name,price,total_tickets,tickets_sold
                 FROM events
                 WHERE date>=CURDATE() AND total_tickets>tickets_sold
                 LIMIT 5"
            )->fetchAll(PDO::FETCH_ASSOC);
            if (empty($rows)) {
                return $this->end("All tickets are sold out.");
            }
            $menu = "Available Events:\n";
            foreach ($rows as $i => $e) {
                $left = $e['total_tickets'] - $e['tickets_sold'];
                $menu .= ($i+1) . ". {$e['name']} ({$left} left)\n";
            }
            $menu .= Util::GO_BACK . ". Back";
            return $this->con($menu);
        }

        if ($lvl === 3 && $a[1] === '1') {
            $idx = (int)$a[2] - 1;
            $rows = $this->pdo->query(
                "SELECT e.id,e.name,e.price,o.phone AS org_phone
                 FROM events e
                 JOIN organizers o ON e.organizer_id=o.id
                 WHERE date>=CURDATE() AND total_tickets>tickets_sold
                 LIMIT 5"
            )->fetchAll(PDO::FETCH_ASSOC);
            if (!isset($rows[$idx])) {
                return $this->end("Invalid selection.");
            }
            $e = $rows[$idx];
            return $this->con("{$e['name']}\nPrice: " . Util::formatAmount($e['price']) . "\nEnter PIN:");
        }

        if ($lvl === 4 && $a[1] === '1') {
            $pin = $a[3];
            if (!password_verify($pin, $this->user['pin_hash'])) {
                return $this->end("Incorrect PIN.");
            }
            $idx = (int)$a[2] - 1;
            $rows = $this->pdo->query(
                "SELECT e.id,e.name,e.price,o.phone AS org_phone
                 FROM events e
                 JOIN organizers o ON e.organizer_id=o.id
                 WHERE date>=CURDATE() AND total_tickets>tickets_sold
                 LIMIT 5"
            )->fetchAll(PDO::FETCH_ASSOC);
            $e = $rows[$idx] ?? null;
            if (!$e) {
                return $this->end("Invalid selection.");
            }
            $momo = new Momo();
            $balance = $momo->checkBalance($this->phone);
            if ($balance < $e['price']) {
                return $this->end("Insufficient MoMo balance.");
            }
            $res = $momo->sendMoney($this->phone, $e['org_phone'], $e['price']);
            if ($res['status'] !== 'SUCCESS') {
                return $this->end("Payment failed: " . $res['message']);
            }
            $this->pdo->prepare(
                "INSERT INTO tickets(event_id,user_id,total) VALUES(?,(SELECT id FROM users WHERE phone_number=?),?)"
            )->execute([$e['id'], $this->phone, $e['price']]);
            $this->pdo->prepare(
                "UPDATE events SET tickets_sold = tickets_sold + 1 WHERE id = ?"
            )->execute([$e['id']]);
            $ref = Util::generateReference();
            $this->sms->sendSMS("You bought 1×{$e['name']} for " . Util::formatAmount($e['price']) . ". Ref: {$ref}", $this->phone);
            return $this->end("Ticket purchased! Ref: {$ref}");
        }

        if ($lvl === 2 && $a[1] === '2') {
            $rows = $this->pdo->query(
                "SELECT id,name FROM events WHERE date>=CURDATE() LIMIT 5"
            )->fetchAll(PDO::FETCH_ASSOC);
            $menu = "Upcoming Events:\n";
            foreach ($rows as $i => $e) {
                $menu .= ($i+1) . ". {$e['name']}\n";
            }
            $menu .= Util::GO_BACK . ". Back";
            return $this->con($menu);
        }

        if ($lvl === 3 && $a[1] === '2') {
            $rows = $this->pdo->query("SELECT * FROM events WHERE date>=CURDATE() LIMIT 5")->fetchAll(PDO::FETCH_ASSOC);
            $e = $rows[(int)$a[2]-1] ?? null;
            if (!$e) {
                return $this->end("Invalid selection.");
            }
            return $this->con(
                "{$e['name']}\nDate: {$e['date']}\nLoc: {$e['location']}\nPrice: " .
                Util::formatAmount($e['price']) . "\n\n1. Buy Ticket\n" . Util::GO_BACK . ". Back"
            );
        }

        if ($lvl === 4 && $a[1] === '2' && $a[3] === '1') {
            return $this->flowEventServices([1,'1',$a[2]]);
        }

        if ($lvl === 2 && $a[1] === '3') {
            if (!$this->isOrganizer()) {
                return $this->con("Enter your brand name:");
            }
            return $this->con("Organizer Menu:\n1. Add New Event\n2. View My Events\n" . Util::GO_BACK . ". Back");
        }

        if ($lvl === 3 && $a[1] === '3' && !$this->isOrganizer()) {
            $brand = Util::sanitizeInput($a[2]);
            $this->pdo->prepare("UPDATE users SET role='organizer' WHERE phone_number=?")->execute([$this->phone]);
            $this->pdo->prepare(
                "INSERT INTO organizers(user_id,full_name,brand_name,phone) VALUES((SELECT id FROM users WHERE phone_number=?),?,?,?)"
            )->execute([$this->phone, $this->user['full_name'], $brand, $this->phone]);
            $this->sms->sendSMS("Hi {$this->user['full_name']}, you are now an organizer for {$brand}.", $this->phone);
            return $this->con("Organizer Menu:\n1. Add New Event\n2. View My Events\n" . Util::GO_BACK . ". Back");
        }

        if ($this->isOrganizer()) {
            if ($lvl === 3 && $a[1] === '3') {
                if ($a[2] === '1') {
                    return $this->con("Enter Event Name:");
                }
                if ($a[2] === '2') {
                    $rows = $this->pdo->prepare("SELECT name,date,location FROM events WHERE organizer_id=(SELECT id FROM organizers WHERE phone=?)");
                    $rows->execute([$this->phone]);
                    $events = $rows->fetchAll(PDO::FETCH_ASSOC);
                    if (empty($events)) {
                        return $this->end("No events found.");
                    }
                    $msg = "Your Events:\n";
                    foreach ($events as $ev) {
                        $msg .= "- {$ev['name']} ({$ev['date']}, {$ev['location']})\n";
                    }
                    $this->sms->sendSMS($msg, $this->phone);
                    return $this->end("Your events have been sent via SMS.");
                }
            }
            if ($lvl === 4 && $a[1] === '3' && $a[2] === '1') {
                return $this->con("Enter Event Date (YYYY-MM-DD):");
            }
            if ($lvl === 5 && $a[1] === '3' && $a[2] === '1') {
                return $this->con("Enter Location:");
            }
            if ($lvl === 6 && $a[1] === '3' && $a[2] === '1') {
                return $this->con("Enter Price:");
            }
            if ($lvl === 7 && $a[1] === '3' && $a[2] === '1') {
                return $this->con("Enter Total Tickets:");
            }
            if ($lvl === 8 && $a[1] === '3' && $a[2] === '1') {
                list(,,,$_name,$_date,$_loc,$_price,$_total) = $a;
                $stmt = $this->pdo->prepare("SELECT id FROM organizers WHERE phone = ?");
                $stmt->execute([$this->phone]);
                $orgId = $stmt->fetchColumn();
                $this->pdo->prepare(
                    "INSERT INTO events(name,date,location,price,total_tickets,tickets_sold,organizer_id)
                     VALUES(?,?,?,?,?,0,?)"
                )->execute([$_name,$_date,$_loc,$_price,$_total,$orgId]);
                $this->sms->sendSMS("Event '{$_name}' on {$_date} at {$_loc} created successfully.", $this->phone);
                return $this->end("Event '{$_name}' added! Confirmation SMS sent.");
            }
        }

        return $this->end("Thank you for using EventMint.");
    }

    public function flowMomoServices($a) {
        $lvl = count($a);

        if ($lvl === 1) {
            return $this->con("MoMo Services:\n1. Check Balance\n2. Send Money\n" . Util::GO_BACK . ". Back");
        }

        if ($lvl === 2) {
            return $this->con("Enter your 4‑digit PIN:");
        }

        $pin = $a[2];
        if (!password_verify($pin, $this->user['pin_hash'])) {
            return $this->end("Incorrect PIN.");
        }

        if ($a[1] === '1' && $lvl === 3) {
            $bal = (new Momo())->checkBalance($this->phone);
            $msg = "Your MoMo balance: " . Util::formatAmount($bal);
            $this->sms->sendSMS($msg, $this->phone);
            return $this->end($msg);
        }

        if ($a[1] === '2') {
            if ($lvl === 3) {
                return $this->con("Enter recipient phone (E.164):");
            }
            if ($lvl === 4) {
                return $this->con("Enter amount to send:");
            }
            if ($lvl === 5) {
                $to     = Util::sanitizeInput($a[3]);
                $amount = (int)$a[4];
                $res = (new Momo())->sendMoney($this->phone, $to, $amount);
                if ($res['status'] === 'SUCCESS') {
                    $msg = "Sent " . Util::formatAmount($amount) . " to {$to}. Ref: {$res['reference']}";
                    $this->sms->sendSMS($msg, $this->phone);
                    return $this->end($msg);
                } else {
                    return $this->end("Transfer failed: " . $res['message']);
                }
            }
        }

        return $this->end("Invalid selection.");
    }

    public function flowSupport($a) {
        $msg = "For support call:\n+250792359800\n+250792524900";
        $this->sms->sendSMS($msg, $this->phone);
        return $this->end($msg);
    }
}