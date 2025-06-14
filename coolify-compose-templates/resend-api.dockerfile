FROM oven/bun:alpine

WORKDIR /app

RUN bun add cors express resend zod zod-express-middleware

RUN cat <<EOF > ./index.ts
import { Resend } from 'resend';
import express from 'express'
import cors from 'cors'
import {z} from 'zod'
import {validateRequest} from 'zod-express-middleware'

const resendToken = Bun.env?.RESEND_TOKEN
const toMails = Bun.env?.TO_MAILS
const port = Bun.env?.PORT ?? 8080

if (!resendToken) {
  console.error('No Resend Token !')
  process.exit(1)
}

const resend = new Resend(resendToken)
const app = express()

app.get('/', (_, res) => {
  res.send(Math.round(Math.random() / 0.5) ? 'yes' : 'no')
});

app.use(cors({
  origin: (origin, callback) => {
    const re = /https:\/\/(.+\.)?walkingfolks\.com\/?/
    if (origin && Boolean(origin.match(re))) {
      callback(null, true)
    } else {
      callback(new Error('Not allowed by CORS'))
    }
  },
  methods: ['POST', 'GET'],
  allowedHeaders: ['Content-Type'],
}))

app.use(express.json())

const contactSchema = z.object({
  name: z.string().min(2),
  email: z.string().email(),
  subject: z.string().min(5),
  message: z.string().min(10),
  phone: z.string().nullish(),
})

app.post('/api/contact', validateRequest({body: contactSchema}), async (req, res) => {
  try {
    await resend.emails.send({
      from: 'Contact Form <contact@walkingfolks.com>',
      to: toMails?.split(',').map(s => s.trim()) ?? [''],
      subject: 'New Contact Form Submission: ' + req.body.subject,
      text: [
        'Name: ' + req.body.name,
        'Email: ' + req.body.email,
        'Phone: ' + req.body.phone || 'Not provided',
        'Subject: ' + req.body.subject,
        'Message: ' + req.body.message,
      ].join('\n'),
      html: [
        '<h2>New Contact Form Submission</h2>',
        '<p><strong>Name:</strong> ' + req.body.name + '</p>',
        '<p><strong>Email:</strong> ' + req.body.email + '</p>',
        '<p><strong>Phone:</strong> ' + (req.body.phone ?? 'Not provided') + '</p>',
        '<p><strong>Subject:</strong> ' + req.body.subject + '</p>',
        '<p><strong>Message:</strong> ' + req.body.message + '</p>',
      ].join('\n')
    })
    res.status(200).json({success: true, message: 'Message sent successfully'})
  } catch (error) {
    console.error('Error sending email:', error)
    res.status(500).json({success: false, message: 'Failed to send message. Please try again.'})
  }
})

app.get('/health', (_, res) => {
  res.status(200).send('OK')
})

app.listen(port, () => {
  console.log('!@', 'Listening on port: ' + port)
})
EOF

HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
  CMD curl -f http://localhost/health || exit 1

CMD ["bun", "./index.ts"]
