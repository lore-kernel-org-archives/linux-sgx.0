Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B44FC5519F
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10E3F2223F
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:04:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="MnaLy22J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgKLWEU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Nov 2020 17:04:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727857AbgKLWEU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Nov 2020 17:04:20 -0500
Received: from suppilovahvero.lan (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC60322246;
        Thu, 12 Nov 2020 22:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605218659;
        bh=GbI4CGnBFEA+npROLTvsvNQizyIPaccrpO+b2Gc9aEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MnaLy22JZT5NQu5LsqaqgXRj8CwsWTw65YxZhWxA70ZBvKXUv5jn+N65k/gXHjSuk
         7dxpdy1EpAASHTXHaKaOULgJfEzy30yp7DcqOiV38g9XqsBHoQ6K8DhNJs8+yDKHgZ
         7aJgB/Vv72Gm9J0z9QeG2QI5L6xf4+q+gMGbEVDo=
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: [PATCH v41 24/24] x86/sgx: Update MAINTAINERS
Date:   Fri, 13 Nov 2020 00:01:35 +0200
Message-Id: <20201112220135.165028-25-jarkko@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201112220135.165028-1-jarkko@kernel.org>
References: <20201112220135.165028-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add the maintainer information for the SGX subsystem.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Acked-by: Jethro Beekman <jethro@fortanix.com> # v40
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 MAINTAINERS | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0b75ed0f06d8..20602ac130f0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9126,6 +9126,19 @@ F:	Documentation/x86/intel_txt.rst
 F:	arch/x86/kernel/tboot.c
 F:	include/linux/tboot.h
 
+INTEL SGX
+M:	Jarkko Sakkinen <jarkko@kernel.org>
+L:	linux-sgx@vger.kernel.org
+S:	Supported
+Q:	https://patchwork.kernel.org/project/intel-sgx/list/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-sgx.git
+F:	Documentation/x86/sgx.rst
+F:	arch/x86/entry/vdso/vsgx.S
+F:	arch/x86/include/uapi/asm/sgx.h
+F:	arch/x86/kernel/cpu/sgx/*
+F:	tools/testing/selftests/sgx/*
+K:	\bSGX_
+
 INTERCONNECT API
 M:	Georgi Djakov <georgi.djakov@linaro.org>
 L:	linux-pm@vger.kernel.org
-- 
2.27.0

