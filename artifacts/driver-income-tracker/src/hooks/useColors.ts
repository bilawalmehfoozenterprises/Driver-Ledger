import { colors } from '@/theme';

export function useColors() {
  // Keep the scaffold's existing hook working while the app is light-theme only.
  return {
    ...colors,
    // Compatibility aliases for the existing foundation components.
    foreground: colors.text,
    card: colors.surface,
    mutedForeground: colors.textSecondary,
  };
}