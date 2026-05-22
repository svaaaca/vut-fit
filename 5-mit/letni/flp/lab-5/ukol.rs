#[derive(Debug, PartialEq)]
struct Account {
    id: u32,
    balance: i32,
    holder: String,
}

#[derive(Debug, PartialEq)]
struct Bank {
    accounts: Vec<Account>,
}

#[derive(Debug, PartialEq)]
enum BankError {
    AccountNotFound(u32),
    InsufficientFunds { id: u32, balance: i32, requested: i32 },
}

impl Account {
    fn new(id: u32, holder: String) -> Self {
        // Konstruktor - vytvori novy ucet s `id` a vlastnikem `holder`.
        // Pocatecni vyse zustatku bude 0.
        Account {
            id,
            holder,
            balance: 0,
        }
    }

    fn deposit(&mut self, amount: i32) -> i32 {
        // Vlozi na ucet penize o vysi `amount`.
        self.balance += amount;
        self.balance
    }

    fn withdraw(&mut self, amount: i32) -> i32 {
        // Vzbere z uctu penize o vysi `amount`.
        self.balance -= amount;
        self.balance
    }

    fn summary(&self) -> String {
        format!("{} has a balance {}", self.holder, self.balance)
    }
}

impl Bank {
    fn new() -> Self {
        Bank { accounts: vec![] }
    }

    fn add_account(&mut self, account: Account) {
        // Prida ucet do banky.
        self.accounts.push(account);
    }

    fn get_account_id(&self, holder: &str) -> Option<u32> {
        // Vrati ID uctu vlastnika `holder`, existuje-li.
        self.accounts.iter().find(|a| a.holder == holder).map(|a| a.id)
    }

    fn find_account(&self, id: u32) -> Option<&Account> {
        // Vrati immutable (read-only) referenci na ucet s danym `id`, existuje-li.
        self.accounts.iter().find(|a| a.id == id)
    }

    fn find_account_mut(&mut self, id: u32) -> Option<&mut Account> {
        // Vrati mutable referenci na ucet s danym `id`, existuje-li.
        self.accounts.iter_mut().find(|a| a.id == id)
    }

    fn transfer(&mut self, from: u32, to: u32, amount: i32) -> Result<(), BankError> {
        // Provede prevod penez ve vysi `amount` mezi z uctu `from` na `to`.
        // Neexistuje-li nejaky ucet, vraci BankError::AccountNotFound(id).
        // Neni-li dostaten financi, vrati BankError::InsufficientFunds.
        let from_id = self.accounts.iter().position(|a| a.id == from).ok_or(BankError::AccountNotFound(from))?;
        let to_id = self.accounts.iter().position(|a| a.id == to).ok_or(BankError::AccountNotFound(to))?;
        let from_balance = self.accounts[from_id].balance;
        if from_balance < amount {
            return Err(BankError::InsufficientFunds {
                id: from,
                balance: from_balance,
                requested: amount,
            });
        }

        self.accounts[from_id].balance -= amount;
        self.accounts[to_id].balance += amount;
        Ok(())
    }

    fn total_balance(&self) -> i32 {
        // Vrati celkovou sumu zustatku vsech uctu v bance
        self.accounts.iter().map(|a| a.balance).sum()
    }

    fn summary(&self) -> Vec<String> {
        self.accounts.iter().map(|a| a.summary()).collect()
    }
}


// Funkci main() neupravujte !!!
fn main() {
    // =======================
    // Testy na Account (1 b)
    // =======================
    let mut a = Account::new(1, String::from("Petr Novak"));

    println!("{:#?}", a);

    assert_eq!(a.balance, 0);

    assert_eq!(a.deposit(100), 100);
    assert_eq!(a.balance, 100);

    assert_eq!(a.withdraw(40), 60);
    assert_eq!(a.balance, 60);

    println!("{:#?}", a);

    assert_eq!(a.summary(), "Petr Novak has a balance 60");
    println!("*** PRVNI CAST OK ***");

    // ====================
    // Testy na Bank (1 b)
    // ====================
    let mut bank = Bank::new();

    let mut alice = Account::new(1001, String::from("Alice Novakova"));
    let mut robert = Account::new(1002, String::from("Robert Svoboda"));
    let mut karolina = Account::new(1003, String::from("Karolina Dvorakova"));
    let mut david = Account::new(1004, String::from("David Kral"));

    alice.deposit(1000);
    robert.deposit(200);
    karolina.deposit(50);
    david.deposit(0);

    bank.add_account(alice);
    bank.add_account(robert);
    bank.add_account(karolina);
    bank.add_account(david);

    println!("{:#?}", bank.summary());

    // vyhledani id podle jmena majitele
    assert_eq!(bank.get_account_id("Alice Novakova"), Some(1001));
    assert_eq!(bank.get_account_id("Nobody"), None);

    // celkovy soucet zustatku
    assert_eq!(bank.total_balance(), 1000 + 200 + 50 + 0);

    // prevod: nejdriv zjistime id podle jmen
    let alice_id = bank.get_account_id("Alice Novakova").unwrap();
    let robert_id = bank.get_account_id("Robert Svoboda").unwrap();

    // uspesny prevod
    assert!(bank.transfer(alice_id, robert_id, 300).is_ok());
    assert_eq!(bank.find_account(alice_id).unwrap().balance, 700);
    assert_eq!(bank.find_account(robert_id).unwrap().balance, 500);

    println!("{:#?}", bank.summary());

    // celkova suma se prevodem nemeni
    assert_eq!(bank.total_balance(), 1000 + 200 + 50 + 0);

    // neuspesny prevod (nedostatek penez)
    let res = bank.transfer(robert_id, alice_id, 10_000);
    assert!(matches!(res, Err(BankError::InsufficientFunds { .. })));

    // neuspesny prevod (ucet neexistuje)
    let res2 = bank.transfer(9999, alice_id, 1);
    assert_eq!(res2, Err(BankError::AccountNotFound(9999)));

    println!("{:#?}", bank.summary());
    println!("total={}", bank.total_balance());
    println!("*** DRUHA CAST OK ***");
}
