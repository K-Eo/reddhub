export const sanitizeNewLines = (text: string): string => {
  return text.replace(/\r\n?/g, '\n')
}
