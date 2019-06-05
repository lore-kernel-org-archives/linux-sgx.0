Return-Path: <SRS0=6XgF=UE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF870C28CC5
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 15:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D075D2067C
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 15:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbfFEPPl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Jun 2019 11:15:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:43679 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728132AbfFEPPl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Jun 2019 11:15:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 08:15:40 -0700
X-ExtLoop1: 1
Received: from araresx-wtg1.ger.corp.intel.com (HELO localhost) ([10.252.46.102])
  by fmsmga001.fm.intel.com with ESMTP; 05 Jun 2019 08:15:30 -0700
Date:   Wed, 5 Jun 2019 18:15:24 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
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
Subject: Re: [RFC PATCH 2/9] x86/sgx: Do not naturally align MAP_FIXED address
Message-ID: <20190605151524.GJ11331@linux.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-3-sean.j.christopherson@intel.com>
 <20190604114951.GC30594@linux.intel.com>
 <CALCETrVe0jhAWAFmx+NFEjJcijSJv2LDVC7cUXi0w99kNKjh_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVe0jhAWAFmx+NFEjJcijSJv2LDVC7cUXi0w99kNKjh_g@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 04, 2019 at 01:16:04PM -0700, Andy Lutomirski wrote:
> On Tue, Jun 4, 2019 at 4:50 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Fri, May 31, 2019 at 04:31:52PM -0700, Sean Christopherson wrote:
> > > SGX enclaves have an associated Enclave Linear Range (ELRANGE) that is
> > > tracked and enforced by the CPU using a base+mask approach, similar to
> > > how hardware range registers such as the variable MTRRs.  As a result,
> > > the ELRANGE must be naturally sized and aligned.
> > >
> > > To reduce boilerplate code that would be needed in every userspace
> > > enclave loader, the SGX driver naturally aligns the mmap() address and
> > > also requires the range to be naturally sized.  Unfortunately, SGX fails
> > > to grant a waiver to the MAP_FIXED case, e.g. incorrectly rejects mmap()
> > > if userspace is attempting to map a small slice of an existing enclave.
> > >
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >
> > Why you want to allow mmap() to be called multiple times? mmap() could
> > be allowed only once with PROT_NONE and denied afterwards. Is this for
> > sending fd to another process that would map already existing enclave?
> >
> > I don't see any checks for whether the is enclave underneath. Also, I
> > think that in all cases mmap() callback should allow only PROT_NONE
> > as permissions for clarity even if it could called multiple times.
> >
> 
> What's the advantage to only allowing PROT_NONE?  The idea here is to
> allow a PROT_NONE map followed by some replacemets that overlay it for
> the individual segments.  Admittedly, mprotect() can do the same
> thing, but disallowing mmap() seems at least a bit surprising.

I was merely wondering if it is specifically for the application where a
client process would mmap(MAP_FIXED) an enclave created by a server
process.

/Jarkko
