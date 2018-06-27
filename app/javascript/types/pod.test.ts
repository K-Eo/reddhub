import { Story, Pod } from './pod'

describe('Pod', () => {
  test('valid', () => {
    const pod = new Pod()
    pod.content = 'Foo bar'

    expect(pod.isValid()).toBeTruthy()
    expect(pod.errors).toHaveLength(0)
  })

  test('invalid without content', () => {
    const pod = new Pod()

    pod.content = ''
    expect(pod.isValid()).toBeFalsy()
    expect(pod.errors).toHaveLength(1)
    expect(pod.errors).toContain('content_presence')

    pod.content = '\n\n\n\n\n'
    expect(pod.isValid()).toBeFalsy()
    expect(pod.errors).toHaveLength(1)
    expect(pod.errors).toContain('content_presence')
  })

  test('invalid if content is too long', () => {
    const pod = new Pod()
    pod.content = 'a'.repeat(281)

    expect(pod.isValid()).toBeFalsy()
    expect(pod.errors).toHaveLength(1)
    expect(pod.errors).toContain('content_max_length')
  })
})

describe('Story', () => {
  let story: Story = null

  beforeEach(() => {
    story = new Story()
  })

  test('valid', () => {
    story.content = '# Title\n\nDescription\n\nContent'
    expect(story.isValid()).toBeTruthy()
    expect(story.errors).toHaveLength(0)
  })

  test('title with spaces', () => {
    story.content = '# Title Extra\n\nDescription\n\nContent'
    expect(story.isValid()).toBeTruthy()
    expect(story.errors).toHaveLength(0)
  })

  test('description with spaces', () => {
    story.content = '# Title\n\nDescription Extra\n\nContent'
    expect(story.isValid()).toBeTruthy()
    expect(story.errors).toHaveLength(0)
  })

  test('invalid if title is not present', () => {
    story.content = '# \n\nDescription\n\nContent'
    expect(story.isValid()).toBeFalsy()
    expect(story.errors).toContain('format')
    expect(story.errors).toContain('title_presence')
  })

  test('invalid if title is too long', () => {
    story.content = `# ${'a'.repeat(101)}\n\nDescription\n\nContent`
    expect(story.isValid()).toBeFalsy()
    expect(story.errors).toHaveLength(1)
    expect(story.errors).toContain('title_max_length')

    story.content = `# ${'a'.repeat(100)}\n\nDescription\n\nContent`
    expect(story.isValid()).toBeTruthy()
    expect(story.errors).toHaveLength(0)
  })

  test('invalid if description is not present', () => {
    story.content = '# Title\n\n\n\nContent'
    expect(story.isValid()).toBeFalsy()
    expect(story.errors).toContain('format')
    expect(story.errors).not.toContain('title_presence')
    expect(story.errors).toContain('description_presence')
    expect(story.errors).not.toContain('content_presence')
  })

  test('invalid if description is too long', () => {
    story.content = `# Title\n\n${'a'.repeat(151)}\n\nContent`
    expect(story.isValid()).toBeFalsy()
    expect(story.errors).toHaveLength(1)
    expect(story.errors).toContain('description_max_length')

    story.content = `# Title\n\n${'a'.repeat(150)}\n\nContent`
    expect(story.isValid()).toBeTruthy()
    expect(story.errors).toHaveLength(0)
  })

  test('invalid if content is not present', () => {
    story.content = '# Title\n\nDescription\n\n'
    expect(story.isValid()).toBeFalsy()
    expect(story.errors).toContain('format')
    expect(story.errors).not.toContain('title_presence')
    expect(story.errors).not.toContain('description_presence')
    expect(story.errors).toContain('content_presence')
  })

  test('parsing story', () => {
    story.content = '# Title\n\nDescription\n\nContent\n\nFooter'
    expect(story.isValid()).toBeTruthy()
    expect(story.title).toBe('Title')
    expect(story.description).toBe('Description')
    expect(story.content).toBe('Content\n\nFooter')
  })

  const invalidStories = [
    ['', false],
    ['\n# My title\n\nMy description', false],
    ['My title\n\nMy description', false],
    ['#  My title\n\nMy description', false],
    ['#My title\n\nMy description', false],
    ['# My title\n\nMy description\n', false],
    ['# My title\n\nMy description\n\n ', false],
    ['# My title\n\nMy description', false],
    ['## My title\n\nMy description', false],
    [' My title\n\nMy description', false],
  ]

  test.each(invalidStories)(
    "story.isValid() with '%s'",
    (content, expected) => {
      story.content = content
      expect(story.isValid()).toBe(expected)
    }
  )

  const expectations = [
    ['# ', true],
    [' # ', false],
    [' # F', false],
    ['F', false],
    ['\n# F', false],
    ['#', false],
    ['# \nfoo', true],
  ]

  test.each(expectations)(
    "Story.hasStorySignature('%s')",
    (content, expected) => {
      expect(Story.hasSignature(content)).toBe(expected)
    }
  )
})
