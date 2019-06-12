Return-Path: <SRS0=wmvE=UL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BDCC31E47
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jun 2019 19:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80A722177E
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jun 2019 19:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbfFLT0i (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Jun 2019 15:26:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:24089 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbfFLT0g (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 12 Jun 2019 15:26:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jun 2019 12:26:35 -0700
X-ExtLoop1: 1
Received: from suygunge-mobl.ger.corp.intel.com (HELO localhost) ([10.252.48.116])
  by orsmga001.jf.intel.com with ESMTP; 12 Jun 2019 12:26:27 -0700
Date:   Wed, 12 Jun 2019 22:26:26 +0300
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
Message-ID: <20190612192626.GD3378@linux.intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-3-sean.j.christopherson@intel.com>
 <20190610152717.GB3752@linux.intel.com>
 <20190610161532.GC15995@linux.intel.com>
 <20190610174506.GB13732@linux.intel.com>
 <20190610181744.GH15995@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610181744.GH15995@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 10, 2019 at 11:17:44AM -0700, Sean Christopherson wrote:
> On Mon, Jun 10, 2019 at 08:45:06PM +0300, Jarkko Sakkinen wrote:
> > On Mon, Jun 10, 2019 at 09:15:33AM -0700, Sean Christopherson wrote:
> > > > 'flags' should would renamed as 'secinfo_flags_mask' even if the name is
> > > > longish. It would use the same values as the SECINFO flags. The field in
> > > > struct sgx_encl_page should have the same name. That would express
> > > > exactly relation between SECINFO and the new field. I would have never
> > > > asked on last iteration why SECINFO is not enough with a better naming.
> > > 
> > > No, these flags do not impact the EPCM protections in any way.  Userspace
> > > can extend the EPCM protections without going through the kernel.  The
> > > protection flags for an enclave page impact VMA/PTE protection bits.
> > > 
> > > IMO, it is best to treat the EPCM as being completely separate from the
> > > kernel's EPC management.
> > 
> > It is a clumsy API if permissions are not taken in the same format for
> > everything. There is no reason not to do it. The way mprotect() callback
> > just interprets the field is as VMA permissions.
> 
> They are two entirely different things.  The explicit protection bits are
> consumed by the kernel, while SECINFO.flags is consumed by the CPU.  The
> intent is to have the protection flags be analogous to mprotect(), the
> fact that they have a similar/identical format to SECINFO is irrelevant.
> 
> Calling the field secinfo_flags_mask is straight up wrong on SGX2, as 
> userspace can use EMODPE to set SECINFO after the page is added.  It's
> also wrong on SGX1 when adding TCS pages since SECINFO.RWX bits for TCS
> pages are forced to zero by hardware.

The new variable tells the limits on which kernel will co-operate with
the enclave. It is way more descriptive than 'flags'.

> > It would also be more future-proof just to have a mask covering all bits
> > of the SECINFO flags field.
> 
> This simply doesn't work, e.g. the PENDING, MODIFIED and PR flags in the
> SECINFO are read-only from a software perspective.

It is easy to validate reserved bits from a SECINFO struct.

/Jarkko
