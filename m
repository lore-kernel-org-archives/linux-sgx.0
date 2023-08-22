Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4123EE49A5
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Aug 2023 20:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbjHVUjU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Aug 2023 16:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjHVUjT (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 22 Aug 2023 16:39:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDC9A8;
        Tue, 22 Aug 2023 13:39:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC71D6467B;
        Tue, 22 Aug 2023 20:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A8EC433C7;
        Tue, 22 Aug 2023 20:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692736757;
        bh=olk3Xa6I7I4/DLU4D9iKqohQ9IwdhSuiwNTWLhb6zxs=;
        h=From:To:Cc:Subject:Date:From;
        b=R55u52RFCQBvWfVjXeXFdT43jvwopNLC2wbs/krHtWGCH4kH7eRlpNgiXJ+t7dPHu
         Xnag1SpjT+Cr4ii1N4dGpIZvZPsRLXfSGtzxFuZ+O++ach9DjnbQZMct8WYH4kZxPg
         wVc+BEzLfRr0TvO++BGnU30hhXYr2XNDZXjsoT61eRt5TuWSzfzmoW9CilTKQxPvXa
         nKcYCNnJVNUasPrn2zsEBdSWb8MjcJWaYhkg5vbpfilXjkguVg4cP4wihTbM2Q8Evo
         Wi/wXuTuKabVI5dLr0cLWQlFJ9qFd6u4PrZ3fgzA3JlNaRpm7vPAy+5gKRQcmI8kjn
         S2iDr37kSJVfg==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Jerry Snitselaar <jsnitsel@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org,
        Todd Brandt <todd.e.brandt@intel.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Mario Limonciello <mario.limonciello@amd.com>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] tpm: Enable hwrng only for Pluton on AMD CPUs
Date:   Tue, 22 Aug 2023 23:39:12 +0300
Message-Id: <20230822203912.2256229-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The vendor check introduced by commit 554b841d4703 ("tpm: Disable RNG for
all AMD fTPMs") doesn't work properly on a number of Intel fTPMs.  On the
reported systems the TPM doesn't reply at bootup and returns back the
command code. This makes the TPM fail probe.

Since only Microsoft Pluton is the only known combination of AMD CPU and
fTPM from other vendor, disable hwrng otherwise. In order to make sysadmin
aware of this, print also info message to the klog.

Cc: stable@vger.kernel.org
Fixes: 554b841d4703 ("tpm: Disable RNG for all AMD fTPMs")
Reported-by: Todd Brandt <todd.e.brandt@intel.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217804
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
v2:
* CONFIG_X86
* Removed "Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>"
* Removed "Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>"
---
 drivers/char/tpm/tpm_crb.c | 31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 65ff4d2fbe8d..28448bfd4062 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -463,28 +463,6 @@ static bool crb_req_canceled(struct tpm_chip *chip, u8 status)
 	return (cancel & CRB_CANCEL_INVOKE) == CRB_CANCEL_INVOKE;
 }
 
-static int crb_check_flags(struct tpm_chip *chip)
-{
-	u32 val;
-	int ret;
-
-	ret = crb_request_locality(chip, 0);
-	if (ret)
-		return ret;
-
-	ret = tpm2_get_tpm_pt(chip, TPM2_PT_MANUFACTURER, &val, NULL);
-	if (ret)
-		goto release;
-
-	if (val == 0x414D4400U /* AMD */)
-		chip->flags |= TPM_CHIP_FLAG_HWRNG_DISABLED;
-
-release:
-	crb_relinquish_locality(chip, 0);
-
-	return ret;
-}
-
 static const struct tpm_class_ops tpm_crb = {
 	.flags = TPM_OPS_AUTO_STARTUP,
 	.status = crb_status,
@@ -827,9 +805,12 @@ static int crb_acpi_add(struct acpi_device *device)
 	if (rc)
 		goto out;
 
-	rc = crb_check_flags(chip);
-	if (rc)
-		goto out;
+	/* A quirk for https://www.amd.com/en/support/kb/faq/pa-410 */
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
+	    priv->sm != ACPI_TPM2_COMMAND_BUFFER_WITH_PLUTON) {
+		dev_info(dev, "Disabling hwrng\n");
+		chip->flags |= TPM_CHIP_FLAG_HWRNG_DISABLED;
+	}
 
 	rc = tpm_chip_register(chip);
 
-- 
2.39.2

