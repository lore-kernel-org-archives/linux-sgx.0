Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D9DC4360C
	for <linux-sgx@archiver.kernel.org>; Wed, 12 May 2021 12:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0508361104
	for <linux-sgx@archiver.kernel.org>; Wed, 12 May 2021 12:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbhELMxb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 May 2021 08:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231513AbhELMxA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 12 May 2021 08:53:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 167AA61469;
        Wed, 12 May 2021 12:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620823903;
        bh=5grcpmVWK6qFXGk84Uc7pxJTRe6T83rcuW2ekjlJZ/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRD8okc4zu3jTa2huY7IN/0Gw30InHdOBTA0JnnqfjFsd4u7dXS9jKeCZrWQ2mR5v
         5PALdyrT1cPyl30hJZnNlQZyAPwAdtBAIl+yC6v/68ZoAYqlk/k0NZEm3K3442BE2c
         SbwV+c3mqX75Fzz3ih4TdGdNNy/27VcNcuygC4soJdNlYW7lbsBtx8i4oV56HjP9sV
         v0ZxMpIvlShBRO8Bx95DEh5UfNSm57BKg9WewQQo/HoXkbKr35YRl/F3Z1qK0o09K2
         P6RJJTRf/toWaUmoMU9Yaw1cVO/7QjqVFk8z+Nmb+/iY7QveKavqMmc3DmQ0TzNYQU
         6fKXyJMouHEJQ==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1lgoKz-0018iY-82; Wed, 12 May 2021 14:51:41 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Jonathan Corbet" <corbet@lwn.net>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        x86@kernel.org
Subject: [PATCH v2 27/40] docs: x86: Use ASCII subset instead of UTF-8 alternate symbols
Date:   Wed, 12 May 2021 14:50:31 +0200
Message-Id: <7af1f56ef0237c6adeea85e4d4155b872db21b34.1620823573.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1620823573.git.mchehab+huawei@kernel.org>
References: <cover.1620823573.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The conversion tools used during DocBook/LaTeX/Markdown->ReST conversion
and some automatic rules which exists on certain text editors like
LibreOffice turned ASCII characters into some UTF-8 alternatives that
are better displayed on html and PDF.

While it is OK to use UTF-8 characters in Linux, it is better to
use the ASCII subset instead of using an UTF-8 equivalent character
as it makes life easier for tools like grep, and are easier to edit
with the some commonly used text/source code editors.

Also, Sphinx already do such conversion automatically outside literal blocks:
   https://docutils.sourceforge.io/docs/user/smartquotes.html

So, replace the occurences of the following UTF-8 characters:

	- U+201c ('“'): LEFT DOUBLE QUOTATION MARK
	- U+201d ('”'): RIGHT DOUBLE QUOTATION MARK

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/x86/resctrl.rst | 2 +-
 Documentation/x86/sgx.rst     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86/resctrl.rst b/Documentation/x86/resctrl.rst
index 71a531061e4e..511cd5b76ed1 100644
--- a/Documentation/x86/resctrl.rst
+++ b/Documentation/x86/resctrl.rst
@@ -519,7 +519,7 @@ Cache pseudo-locking increases the probability that data will remain
 in the cache via carefully configuring the CAT feature and controlling
 application behavior. There is no guarantee that data is placed in
 cache. Instructions like INVD, WBINVD, CLFLUSH, etc. can still evict
-“locked” data from cache. Power management C-states may shrink or
+"locked" data from cache. Power management C-states may shrink or
 power off cache. Deeper C-states will automatically be restricted on
 pseudo-locked region creation.
 
diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
index dd0ac96ff9ef..7ccf63d0d083 100644
--- a/Documentation/x86/sgx.rst
+++ b/Documentation/x86/sgx.rst
@@ -88,7 +88,7 @@ Enclave build functions
 -----------------------
 
 In addition to the traditional compiler and linker build process, SGX has a
-separate enclave “build” process.  Enclaves must be built before they can be
+separate enclave "build" process.  Enclaves must be built before they can be
 executed (entered). The first step in building an enclave is opening the
 **/dev/sgx_enclave** device.  Since enclave memory is protected from direct
 access, special privileged instructions are Then used to copy data into enclave
@@ -147,7 +147,7 @@ Page reclaimer
 
 Similar to the core kswapd, ksgxd, is responsible for managing the
 overcommitment of enclave memory.  If the system runs out of enclave memory,
-*ksgxwapd* “swaps” enclave memory to normal memory.
+*ksgxwapd* "swaps" enclave memory to normal memory.
 
 Launch Control
 ==============
-- 
2.30.2

