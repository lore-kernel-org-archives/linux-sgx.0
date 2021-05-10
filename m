Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D9C0C433ED
	for <linux-sgx@archiver.kernel.org>; Mon, 10 May 2021 10:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36D2C61987
	for <linux-sgx@archiver.kernel.org>; Mon, 10 May 2021 10:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhEJKeC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 May 2021 06:34:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhEJKcB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 May 2021 06:32:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1042C61933;
        Mon, 10 May 2021 10:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620642444;
        bh=wIVKBQpxk8WOlGEpuEDou4htVSzUmtL6P9hqdVeNLYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krQo/PYOAFASHy5IO30w/S2wpTK77+qnjM1nlXIq/v2mIhjIycv7rU9uXGJmUpMdk
         3TksFTnq6T1/HWrJO2nbDk9MtXwijmTyKyJtQOvkY8SJW9bkUPJDaDHbssninKnPVk
         TuA3i6grWBlrm3DizwHTp1ipykStNZ3ffY2XAOD1yKMwHDwF7Eo07+zv5C6jW7T8Ik
         Im8W/SaS24MrN9kP3DYyLnFi8heSsNnOipsWqec1jU7mCHAHb+z30lFdBAkq1+3+we
         hnnN4KGPH5nffBcRab8/g8b4PicDrfniWz6g9KdGQmaDbO9pTS1gth+l8369QK1KUu
         BT2CcvcrUYJ7w==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1lg38E-000UQi-51; Mon, 10 May 2021 12:27:22 +0200
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
Subject: [PATCH 37/53] docs: x86: avoid using UTF-8 chars
Date:   Mon, 10 May 2021 12:26:49 +0200
Message-Id: <466bc4e0f2b37a5a4e7b61453aff804cd0ef5693.1620641727.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1620641727.git.mchehab+huawei@kernel.org>
References: <cover.1620641727.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

While UTF-8 characters can be used at the Linux documentation,
the best is to use them only when ASCII doesn't offer a good replacement.
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

