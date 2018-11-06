Return-Path: <SRS0=XAjE=NR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC7AC32789
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 13:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C227B2083D
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 13:49:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C227B2083D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388323AbeKFXOT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Nov 2018 18:14:19 -0500
Received: from mga03.intel.com ([134.134.136.65]:62413 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388315AbeKFXOT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 6 Nov 2018 18:14:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2018 05:49:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,472,1534834800"; 
   d="scan'208";a="101955741"
Received: from fhoeg-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.66])
  by fmsmga002.fm.intel.com with ESMTP; 06 Nov 2018 05:48:52 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v16 01/22] x86/sgx: Update MAINTAINERS
Date:   Tue,  6 Nov 2018 15:45:40 +0200
Message-Id: <20181106134758.10572-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
References: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181106134540._h248r0lC8uCzEl621XEtCw0Ww_pL8TeL_xU7p33AhI@z>

Add the maintainer information for the SGX subsystem.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 02a39617ec82..a5597a89c7a9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7595,6 +7595,13 @@ L:	linux-gpio@vger.kernel.org
 S:	Maintained
 F:	drivers/gpio/gpio-intel-mid.c
 
+INTEL SGX
+M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+L:	linux-sgx@vger.kernel.org
+Q:	https://patchwork.kernel.org/project/intel-sgx/list/
+F:	drivers/platform/x86/intel_sgx/
+K:	\bSGX_
+
 INVENSENSE MPU-3050 GYROSCOPE DRIVER
 M:	Linus Walleij <linus.walleij@linaro.org>
 L:	linux-iio@vger.kernel.org
-- 
2.19.1

