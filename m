Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A3A3C282CE
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 20:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F250B2070B
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 20:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfFDUeq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jun 2019 16:34:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:52259 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbfFDUeq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Jun 2019 16:34:46 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 13:34:45 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga008.jf.intel.com with ESMTP; 04 Jun 2019 13:34:45 -0700
Date:   Tue, 4 Jun 2019 13:34:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
Subject: Re: [RFC PATCH 7/9] x86/sgx: Enforce noexec filesystem restriction
 for enclaves
Message-ID: <20190604203445.GB7775@linux.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-8-sean.j.christopherson@intel.com>
 <20190604162555.GC3811@linux.intel.com>
 <CALCETrUqcQNbRvBe2UqQih8RHnuwn3KaC=xJU1cRsaEVsCQUgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUqcQNbRvBe2UqQih8RHnuwn3KaC=xJU1cRsaEVsCQUgw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 04, 2019 at 01:25:10PM -0700, Andy Lutomirski wrote:
> On Tue, Jun 4, 2019 at 9:26 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Fri, May 31, 2019 at 04:31:57PM -0700, Sean Christopherson wrote:
> > > Do not allow an enclave page to be mapped with PROT_EXEC if the source
> > > page is backed by a file on a noexec file system.
> > >
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >
> > Why don't you just check in sgx_encl_add_page() that whether the path
> > comes from noexec and deny if SECINFO contains X?
> >
> 
> SECINFO seems almost entirely useless for this kind of thing because
> of SGX2.  I'm thinking that SECINFO should be completely ignored for
> anything other than its required architectural purpose.

Agreed.

I've already (somewhat unknowingly) reworked the SELinux patch such that
it ignores @prot (the SECINFO protections) and only looks at @allowed_prot
(the declared protections).  If the kernel ignores SECINFO protections
entirely then the LSM hook can simply be:

  int selinux_enclave_load(struct vm_area_struct *vma, unsigned long prot)

I.e. LSMs can be blissfully unaware that @prot isn't technically what's
going into the PTEs *now*.
