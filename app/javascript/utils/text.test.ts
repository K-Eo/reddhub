import { sanitizeNewLines } from './text'

test('exists', () => {
  expect(sanitizeNewLines).toBeDefined()
})

test('sanitizes new lines with LF', () => {
  let text = 'foo\nbar'
  expect(sanitizeNewLines(text)).toBe('foo\nbar')

  text = 'foo\n\nbar'
  expect(sanitizeNewLines(text)).toBe('foo\n\nbar')
})

test('sanitizes new lines with CRLF', () => {
  let text = 'foo\r\nbar'
  expect(sanitizeNewLines(text)).toBe('foo\nbar')

  text = 'foo\r\n\r\nbar'
  expect(sanitizeNewLines(text)).toBe('foo\n\nbar')
})

test('sanitizes new lines with CR', () => {
  let text = 'foo\rbar'
  expect(sanitizeNewLines(text)).toBe('foo\nbar')

  text = 'foo\r\rbar'
  expect(sanitizeNewLines(text)).toBe('foo\n\nbar')
})
