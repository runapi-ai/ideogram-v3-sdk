<p align="center">
  <a href="https://runapi.ai"><img src="https://runapi.ai/icon.svg" height="56" alt="RunAPI"></a>
</p>

<h3 align="center">
  <a href="https://github.com/runapi-ai/ideogram-v3-sdk">Ideogram V3 API SDK for RunAPI</a>
</h3>

<p align="center">
  Ideogram V3 API SDKs for JavaScript, Python, Ruby, Go, Java, and PHP on RunAPI.
</p>

<div align="center">

[![npm](https://img.shields.io/npm/v/@runapi.ai/ideogram-v3)](https://www.npmjs.com/package/@runapi.ai/ideogram-v3)
[![PyPI](https://img.shields.io/pypi/v/runapi-ideogram-v3)](https://pypi.org/project/runapi-ideogram-v3/)
[![RubyGems](https://img.shields.io/gem/v/runapi-ideogram-v3)](https://rubygems.org/gems/runapi-ideogram-v3)
[![Go Reference](https://pkg.go.dev/badge/github.com/runapi-ai/ideogram-v3-sdk/go.svg)](https://pkg.go.dev/github.com/runapi-ai/ideogram-v3-sdk/go)
[![Maven Central](https://img.shields.io/maven-central/v/ai.runapi/runapi-ideogram-v3)](https://central.sonatype.com/artifact/ai.runapi/runapi-ideogram-v3)
[![License](https://img.shields.io/github/license/runapi-ai/ideogram-v3-sdk)](https://github.com/runapi-ai/ideogram-v3-sdk/blob/main/LICENSE)

</div>
<br/>

The Ideogram V3 API SDK packages JavaScript, Python, Ruby, Go, Java, and PHP clients for Ideogram V3 on RunAPI. Use it for text-to-image, image remix, reframe, and edit workflows when your app needs typed request builders, predictable task polling, file upload helpers, account helpers, and consistent RunAPI errors.

Ideogram V3 is listed in the RunAPI model catalog at https://runapi.ai/models/ideogram-v3. Variant pages below carry pricing, rate-limit, and commercial-usage details. The public `ideogram-v3-sdk` repository groups the non-PHP language packages, examples, CI, and release tags for this model. The PHP package is released from a split Composer repository.

## Install

```bash
npm install @runapi.ai/ideogram-v3
pip install runapi-ideogram-v3
gem install runapi-ideogram-v3
go get github.com/runapi-ai/ideogram-v3-sdk/go@latest
```

Gradle:

```kotlin
dependencies {
  implementation("ai.runapi:runapi-ideogram-v3:0.1.1")
}
```

Maven:

```xml
<dependency>
  <groupId>ai.runapi</groupId>
  <artifactId>runapi-ideogram-v3</artifactId>
  <version>0.1.1</version>
</dependency>
```

Use the Java BOM when installing multiple RunAPI Java modules:

```kotlin
dependencies {
  implementation(platform("ai.runapi:runapi-bom:0.1.7"))
  implementation("ai.runapi:runapi-ideogram-v3")
}
```

The PHP package is published from the split Composer repository as `runapi-ai/ideogram-v3`; see https://github.com/runapi-ai/ideogram-v3-php for PHP install and examples.

## What you can build

- Build apps, agent workflows, batch jobs, and production services around Ideogram V3 requests.
- Install only the language package your app needs while keeping one model-specific repository for docs and releases.
- Use `create` for submit-only jobs, `get` for status lookup, and `run` for submit-and-poll scripts.
- Upload local files, URL files, or base64 files through shared RunAPI file helpers.
- Handle validation, authentication, rate limits, insufficient credits, task failures, and polling timeouts through RunAPI SDK errors.

## Java quick start

```java
import ai.runapi.ideogramv3.IdeogramV3Client;
import ai.runapi.ideogramv3.types.TextToImageParams;
import ai.runapi.ideogramv3.types.CompletedTextToImageResponse;
import ai.runapi.ideogramv3.types.TextToImageModel;

IdeogramV3Client client = IdeogramV3Client.builder()
    .apiKey(System.getenv("RUNAPI_API_KEY"))
    .build();

CompletedTextToImageResponse result = client.textToImage().run(
    TextToImageParams.builder()
        .model(TextToImageModel.IDEOGRAM_V3_CHARACTER)
        .prompt("A bold poster reading RUNAPI in crisp lettering")
        .aspectRatio("1:1")
        .build()
);
```

Java packages target Java 8 bytecode and are tested on Java 8, 11, 17, and 21. Each model artifact depends on `ai.runapi:runapi-core`, so application code normally installs only `ai.runapi:runapi-ideogram-v3`.

## Task lifecycle

Most media endpoints are asynchronous. `create()` submits a task and returns its id, `get(id)` fetches the latest task state, and `run(params)` creates the task and polls until it reaches a terminal state. In web request handlers, prefer `create()` plus webhook or later `get()` polling so the server does not hold a worker open.

## Repository layout

- `js/` publishes `@runapi.ai/ideogram-v3`.
- `python/` publishes `runapi-ideogram-v3`.
- `ruby/` publishes `runapi-ideogram-v3`.
- `go/` publishes `github.com/runapi-ai/ideogram-v3-sdk/go` and depends on `github.com/runapi-ai/core-sdk/go`.
- `java/` publishes `ai.runapi:runapi-ideogram-v3` and depends on `ai.runapi:runapi-core`.

## Public links

- Model page: https://runapi.ai/models/ideogram-v3
- SDK docs: https://runapi.ai/docs#sdk-ideogram-v3
- Product docs: https://runapi.ai/docs#ideogram-v3
- SDK repository: https://github.com/runapi-ai/ideogram-v3-sdk
- PHP package repository: https://github.com/runapi-ai/ideogram-v3-php
- Skill repository: https://github.com/runapi-ai/ideogram-v3
- Provider comparison: https://runapi.ai/providers/ideogram
- Full catalog: https://runapi.ai/models

## Pricing and variants

Use the most specific Ideogram V3 variant page for pricing, rate limits, and commercial usage:
- [Text to image](https://runapi.ai/models/ideogram-v3/text-to-image)
- [Edit](https://runapi.ai/models/ideogram-v3/edit)
- [Remix](https://runapi.ai/models/ideogram-v3/remix)
- [Character](https://runapi.ai/models/ideogram-v3/character)
- [Character edit](https://runapi.ai/models/ideogram-v3/character-edit)
- [Character remix](https://runapi.ai/models/ideogram-v3/character-remix)
- [Reframe](https://runapi.ai/models/ideogram-v3/reframe)

Default pricing link for the Ideogram V3 SDK: https://runapi.ai/models/ideogram-v3/text-to-image

## File storage

RunAPI-generated file URLs are temporary. Download and store generated images, videos, audio, or other files in your own durable storage within 7 days; do not treat returned URLs as long-term assets.

## FAQ

### Which package should I install for Ideogram V3 work?

Install the model package for your language: `@runapi.ai/ideogram-v3` on npm, `runapi-ideogram-v3` on PyPI, `runapi-ideogram-v3` on RubyGems, `github.com/runapi-ai/ideogram-v3-sdk/go`, `ai.runapi:runapi-ideogram-v3` on Maven Central, or `runapi-ai/ideogram-v3` on Packagist. Install core SDK packages only when you are building shared SDK infrastructure.

### Where should public links point?

Primary Ideogram V3 links point to https://runapi.ai/models/ideogram-v3. Pricing and usage-policy links point to variant pages such as https://runapi.ai/models/ideogram-v3/text-to-image. Provider comparisons point to https://runapi.ai/providers/ideogram, and broad browsing points to https://runapi.ai/models.

## License

Licensed under the Apache License, Version 2.0.
