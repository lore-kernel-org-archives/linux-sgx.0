Return-Path: <SRS0=1VuV=UT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B79CC43613
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 21:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 029EA2070B
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 21:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfFTVR2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Jun 2019 17:17:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:21164 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbfFTVR2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Jun 2019 17:17:28 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 14:17:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; 
   d="scan'208";a="183209548"
Received: from mudigirx-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.61.12])
  by fmsmga004.fm.intel.com with ESMTP; 20 Jun 2019 14:17:15 -0700
Date:   Fri, 21 Jun 2019 00:17:12 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v4 03/12] selftests: x86/sgx: Mark the enclave loader
 as not needing an exec stack
Message-ID: <20190620211700.GH15383@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-4-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619222401.14942-4-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 19, 2019 at 03:23:52PM -0700, Sean Christopherson wrote:
> The SGX enclave loader doesn't need an executable stack, but linkers
> will assume it does due to the lack of .note.GNU-stack sections in the
> loader's assembly code.  As a result, the kernel tags the loader as
> having "read implies exec", and so adds PROT_EXEC to all mmap()s, even
> those for mapping EPC regions.  This will cause problems in the future
> when userspace needs to explicit state a page's protection bits when the
> page is added to an enclave, e.g. adding TCS pages as R+W will cause
> mmap() to fail when the kernel tacks on +X.
> 
> Explicitly tell the linker that an executable stack is not needed.
> Alternatively, each .S file could add .note.GNU-stack, but the loader
> should never need an executable stack so zap it in one fell swoop.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

OK, this one is squashed now. Thanks.

/Jarkko
