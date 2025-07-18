/**
 * Utility functions for number formatting
 */

/**
 * Rounds a number to two decimal places.
 * @param num - The number to round
 * @returns The rounded number
 */
export function roundToTwo(num: number): number {
  // Adding Number.EPSILON to avoid floating-point issues
  return Math.round((num + Number.EPSILON) * 100) / 100;
}

/**
 * Formats a number to two decimal places as a string.
 * Ensures trailing zeros are included.
 * @param num - The number to format
 * @returns The formatted string with two decimal places (e.g., "123.40")
 */
export function formatTwoDecimals(num: number): string {
  return roundToTwo(num).toFixed(2);
} 