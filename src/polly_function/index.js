import { PollyClient, SynthesizeSpeechCommand } from "@aws-sdk/client-polly";
import { S3Client } from "@aws-sdk/client-s3";
import { Upload } from "@aws-sdk/lib-storage";

const polly = new PollyClient({});
const s3 = new S3Client({});

export const handler = async (event) => {
  try {
    const text = event.text;
    const bucketName = process.env.BUCKET_NAME;

    if (!text) {
      return {
        statusCode: 400,
        body: JSON.stringify({ message: "Missing 'text' in request body." }),
      };
    }

    if (!bucketName) {
      throw new Error("BUCKET_NAME environment variable is not set.");
    }

    const params = {
      Text: text,
      OutputFormat: "mp3",
      VoiceId: "Joanna",
    };

    const command = new SynthesizeSpeechCommand(params);
    const data = await polly.send(command);

    const key = `audio-${Date.now()}.mp3`;

    const upload = new Upload({
      client: s3,
      params: {
        Bucket: bucketName,
        Key: key,
        Body: data.AudioStream,
        ContentType: "audio/mpeg",
      },
    });

    await upload.done();

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: `Audio file stored as ${key}`,
        bucket: bucketName,
        key: key,
      }),
    };
  } catch (error) {
    console.error("Error:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Internal server error", error: error.message }),
    };
  }
};
