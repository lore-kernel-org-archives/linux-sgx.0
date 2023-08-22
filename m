Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E3EEE49B2
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Aug 2023 17:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjHVRwb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Aug 2023 13:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjHVRwa (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 22 Aug 2023 13:52:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637BECD9
        for <linux-sgx@vger.kernel.org>; Tue, 22 Aug 2023 10:52:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC75C6149C
        for <linux-sgx@vger.kernel.org>; Tue, 22 Aug 2023 17:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22D7C433C8;
        Tue, 22 Aug 2023 17:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692726747;
        bh=FM/ImYOedgyMG/UeQQ5hyr1gup3KyKWUkOb5ef8p3Gg=;
        h=From:To:Cc:Subject:Date:From;
        b=MUc/wAFZstDSnuc+7ecf4iMZSWI0n3VLM0OpKTDECHkp12wpKqbPNdK/uXkpUKuzO
         Q3IK1hLptb2c29y/EyE27VFbKCMBHJVyNtbdkiMviP1ylMFAAxbUvBNPdWeuT7WxHQ
         s4HqvV1bgImRniaiLUNQc2etTfd3L55Y/CotjEH3hc16zDrY1A0u9M1zNk+r6AgMAJ
         /rWPiJsmGq8OMKXTWOHk2ijIrULuBmqhextR4D6IjuNV90rj1xnj8Z8RC/NzoYDyVq
         ZxT7ILFNaARnow/bTjvdjsqKd5/2CiN5N0sauceJeXEQMYwiWTTQITz2MUDhQdPJHe
         Skd+e7bHCfTXQ==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        William Roberts <bill.c.roberts@gmail.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH v2 0/6] Extend struct tpm_buf to support sized buffers (TPM2B)
Date:   Tue, 22 Aug 2023 20:52:15 +0300
Message-Id: <20230822175221.2196136-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This patch set implements my ideas on how to extend struct tpm_buf to
support TPM2 sized buffers (TPM2B). See Section 10.4 in TPM2 Structures
specification for more information.

The goal is to do initial groundwork for smoother landing of integrity
protection patches by James Bottomley.

I tested the patch set with:

https://github.com/jarkkojs/buildroot-tpmdd/tree/linux-6.5.y

Compilation:

make qemu_x86_64_defconfig
make 2>&1 | tee build.txt;

TPM1 startup: output/images/start-qemu.sh --use-system-swtpm --rtc --tpm1
TPM2 startup: output/images/start-qemu.sh --use-system-swtpm --rtc

For TPM2 I executed the following as the smoke test for these patches:

/usr/lib/kselftests/run_kselftest.sh
tpm2_createprimary --hierarchy o -G rsa2048 -c key.ctxt
tpm2_evictcontrol -c key.ctxt 0x81000001
keyctl add trusted kmk "new 32 keyhandle=0x81000001" @u
keyctl add encrypted 1000100010001000 "new ecryptfs trusted:kmk 64" @u

For TPM1 I tried:

keyctl add trusted kmk "new 32" @u

This caused TPM error 18, which AFAIK means that there is not SRK (?),
which is probably an issue in my swtpm configuration, which is visible
in board/qemu/start-qemu.sh.in.

Link: https://lore.kernel.org/linux-integrity/CT5OE5VZA7D7.3B7C6CK27JIK1@suppilovahvero/
Link: https://lore.kernel.org/linux-integrity/20230403214003.32093-1-James.Bottomley@HansenPartnership.com/
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: William Roberts <bill.c.roberts@gmail.com> 
Cc: Stefan Berger <stefanb@linux.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Mimi Zohar <zohar@linux.ibm.com>

James Bottomley (1):
  tpm: Move buffer handling from static inlines to real functions

Jarkko Sakkinen (5):
  tpm: Store TPM buffer length
  tpm: Detach tpm_buf_reset() from tpm_buf_init()
  tpm: Support TPM2 sized buffers (TPM2B)
  tpm: Add tpm_buf_read_{u8,u16,u32}
  KEYS: trusted: tpm2: Use struct tpm_buf for sized buffers

 drivers/char/tpm/Makefile                 |   1 +
 drivers/char/tpm/tpm-buf.c                | 195 ++++++++++++++++++++++
 drivers/char/tpm/tpm-interface.c          |  18 +-
 drivers/char/tpm/tpm-sysfs.c              |   3 +-
 drivers/char/tpm/tpm1-cmd.c               |  26 ++-
 drivers/char/tpm/tpm2-cmd.c               |  36 ++--
 drivers/char/tpm/tpm2-space.c             |   7 +-
 drivers/char/tpm/tpm_vtpm_proxy.c         |  13 +-
 include/linux/tpm.h                       |  96 ++---------
 security/keys/trusted-keys/trusted_tpm1.c |  12 +-
 security/keys/trusted-keys/trusted_tpm2.c |  60 ++++---
 11 files changed, 325 insertions(+), 142 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-buf.c

-- 
2.39.2

