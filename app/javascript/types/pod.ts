import Model from './model'

export const STORY_REGEX = /^# ([^\n]*)(\n\n)?([^\n]*)(\n\n)?([\s\S]*)$/
export const STORY_REGEX_STRICT = /^# (\S.*)\n\n(\S.*)\n\n(\S[\s\S]*)$/
export const STORY_SIGNATURE = /^# $|^# \S.*/

export class Pod extends Model {
  private _content: string

  constructor() {
    super()
    this._content = ''
  }

  get content(): string {
    return this._content
  }

  set content(content: string) {
    this._content = content
    this.clearErrors()
    this.validateContent()
  }

  private validateContent() {
    const content = this._content.replace(/^\s+|\s+$/g, '')

    if (content.length <= 0) {
      this.pushError('content_presence')
    }

    if (this._content.length > 280) {
      this.pushError('content_max_length')
    }
  }
}

export class Story extends Model {
  private _title: string
  private _description: string
  private _content: string
  private _text: string

  constructor() {
    super()
    this._title = ''
    this._description = ''
    this._content = ''
  }

  get title(): string {
    return this._title
  }

  get description(): string {
    return this._description
  }

  get content(): string {
    return this._content
  }

  set content(content: string) {
    this.clearErrors()
    this._text = content
    this.parse()
    this.validateTitle()
    this.validateDescription()
    this.validateContent()
    this.validateFormat()
  }

  private validateTitle() {
    if (this._title.length <= 0) {
      this.pushError('title_presence')
    }

    if (this._title.length > 100) {
      this.pushError('title_max_length')
    }
  }

  private validateDescription() {
    if (this._description.length <= 0) {
      this.pushError('description_presence')
    }

    if (this._description.length > 150) {
      this.pushError('description_max_length')
    }
  }

  private validateContent() {
    if (this._content.length <= 0) {
      this.pushError('content_presence')
    }
  }

  private validateFormat() {
    if (!STORY_REGEX_STRICT.test(this._text)) {
      this.pushError('format')
    }
  }

  private parse() {
    const matches = this.storyMeta()

    if (matches == null) {
      return
    }

    this._title = matches[1]
    this._description = matches[3]
    this._content = matches[5]
  }

  private storyMeta() {
    return this._text.match(STORY_REGEX)
  }

  static hasSignature(text: string): boolean {
    return STORY_SIGNATURE.test(text)
  }
}
