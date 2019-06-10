Return-Path: <SRS0=YVcv=UJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1847C31E43
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 17:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7EEF2082E
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 17:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388346AbfFJRp1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jun 2019 13:45:27 -0400
Received: from mga06.intel.com ([134.134.136.31]:38816 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388342AbfFJRp1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Jun 2019 13:45:27 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 10:45:26 -0700
X-ExtLoop1: 1
Received: from cmargarx-wtg.ger.corp.intel.com (HELO localhost) ([10.249.34.77])
  by orsmga007.jf.intel.com with ESMTP; 10 Jun 2019 10:45:13 -0700
Date:   Mon, 10 Jun 2019 20:45:06 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
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
Subject: Re: [RFC PATCH v2 2/5] x86/sgx: Require userspace to define enclave
 pages' protection bits
Message-ID: <20190610174506.GB13732@linux.intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-3-sean.j.christopherson@intel.com>
 <20190610152717.GB3752@linux.intel.com>
 <20190610161532.GC15995@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610161532.GC15995@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 10, 2019 at 09:15:33AM -0700, Sean Christopherson wrote:
> > 'flags' should would renamed as 'secinfo_flags_mask' even if the name is
> > longish. It would use the same values as the SECINFO flags. The field in
> > struct sgx_encl_page should have the same name. That would express
> > exactly relation between SECINFO and the new field. I would have never
> > asked on last iteration why SECINFO is not enough with a better naming.
> 
> No, these flags do not impact the EPCM protections in any way.  Userspace
> can extend the EPCM protections without going through the kernel.  The
> protection flags for an enclave page impact VMA/PTE protection bits.
> 
> IMO, it is best to treat the EPCM as being completely separate from the
> kernel's EPC management.

It is a clumsy API if permissions are not taken in the same format for
everything. There is no reason not to do it. The way mprotect() callback
just interprets the field is as VMA permissions.

It would also be more future-proof just to have a mask covering all bits
of the SECINFO flags field.

/Jarkko
