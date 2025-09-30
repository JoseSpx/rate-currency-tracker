import scrapeIt from 'scrape-it';
import { ExchangeRateData } from './interfaces/exchangeRateData.interface.js';
import { saveExchangeRate } from './services/exchangeRate.services.js';
import dotenv from "dotenv";
dotenv.config();


const getExchangeRate = async (): Promise<ExchangeRateData> => {
  console.log("Fetching exchange rate data...");
  let data: any = {};
  try {
    data = await scrapeIt('https://es.investing.com/currencies/usd-pen', {
      exchangeRate: {
        selector: "div[data-test='instrument-price-last']",
        eq: 0
      },
      buyPrice: {
        selector: "dd[data-test='bid'] span:nth-child(2)",
        eq: 0
      },
      sellPrice: {
        selector: "dd[data-test='ask'] span:nth-child(2)",
        eq: 0
      },
    });
  } catch (error) {
    console.error("Error fetching exchange rate data:", error);
    throw error;
  }

  const { exchangeRate, buyPrice, sellPrice } = data.data as ExchangeRateData;

  if (!exchangeRate || !buyPrice || !sellPrice) {
    throw new Error('Failed to fetch exchange rate data');
  }

  console.log(`Exchange Rate: ${exchangeRate}, Buy Price: ${buyPrice}, Sell Price: ${sellPrice}`);

  return { exchangeRate, buyPrice, sellPrice };
}

export const handler = async (event: any) => {
  console.log("Incoming event:", JSON.stringify(event));
  const exchangeRateData = await getExchangeRate();
  await saveExchangeRate(exchangeRateData);

  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "Hello from Lambda with TypeScript 🚀",
      input: event,
    }),
  };
};
