Return-Path: <SRS0=g3U3=T7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF740C04AB6
	for <linux-sgx@archiver.kernel.org>; Fri, 31 May 2019 23:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD1D5259B8
	for <linux-sgx@archiver.kernel.org>; Fri, 31 May 2019 23:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfEaXcb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 31 May 2019 19:32:31 -0400
Received: from mga07.intel.com ([134.134.136.100]:59345 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbfEaXcb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 31 May 2019 19:32:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 16:32:30 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga008.jf.intel.com with ESMTP; 31 May 2019 16:32:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Cedric Xing <cedric.xing@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Haitao Huang <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai Huang <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        William Roberts <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
Subject: [RFC PATCH 1/9] x86/sgx: Remove unused local variable in sgx_encl_release()
Date:   Fri, 31 May 2019 16:31:51 -0700
Message-Id: <20190531233159.30992-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531233159.30992-1-sean.j.christopherson@intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 7216bdf07bd0..f23ea0fbaa47 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -463,7 +463,6 @@ EXPORT_SYMBOL_GPL(sgx_encl_destroy);
 void sgx_encl_release(struct kref *ref)
 {
 	struct sgx_encl *encl = container_of(ref, struct sgx_encl, refcount);
-	struct sgx_encl_mm *encl_mm;
 
 	if (encl->pm_notifier.notifier_call)
 		unregister_pm_notifier(&encl->pm_notifier);
-- 
2.21.0

