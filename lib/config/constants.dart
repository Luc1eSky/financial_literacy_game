const String appTitle = 'FinSim Game';

// confetti duration in seconds
const int showConfettiSeconds = 3;

// maximum Width of play area
const double playAreaMaxWidth = 600;

// aspect ratio of overview content cards (cash, income, expenses)
const double overviewAspectRatio = 1.4;

// aspect ratio of asset content cards (cows, chickens, goats)
const double assetsAspectRatio = 0.8;

// decimal points for borrow and interest rates
// on "investment options" screen
const int decimalValuesToDisplay = 0;

// initial values when new level starts
const double defaultLevelStartMoney = 5;
const double defaultPersonalIncome = 8;
const double defaultPersonalExpenses = 7;

// default values
const int defaultLifeSpan = 6;
const int defaultLoanTerm = 2;
const double defaultCashInterest = 0.05; // used when not randomized

// limits for random values
const double minimumSavingsRate = 0.0;
const double maximumSavingsRate = 0.10;
const double stepsSavingsRate = 0.05;

const double minimumInterestRate = 0.15;
const double maximumInterestRate = 0.30;
const double stepsInterestRate = 0.05;

const double minimumRiskLevel = 0.20;
const double maximumRiskLevel = 0.40;
const double stepsRiskLevel = 0.05;

const double priceVariation = 0.20; // varies price of asset by +/- 20%
const int incomeVariation = 1; // varies income of asset by +/- $1
