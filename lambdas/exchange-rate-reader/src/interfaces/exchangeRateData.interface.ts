export interface ExchangeRateData {
  id?: string; // Will be generated if not provided
  timestamp?: number; // Unix timestamp
  exchangeRate: string;
  buyPrice: string;
  sellPrice: string;
}