Return-Path: <SRS0=httf=UQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A2FC31E5B
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 16:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B440A20863
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 16:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfFQQtS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Jun 2019 12:49:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:41735 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfFQQtS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Jun 2019 12:49:18 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 09:49:17 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga004.fm.intel.com with ESMTP; 17 Jun 2019 09:49:15 -0700
Date:   Mon, 17 Jun 2019 09:49:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        Cedric Xing <cedric.xing@intel.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-sgx@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        pmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
Subject: Re: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in
 SELinux
Message-ID: <20190617164915.GA25085@linux.intel.com>
References: <cover.1560131039.git.cedric.xing@intel.com>
 <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
 <20190611220243.GB3416@linux.intel.com>
 <8d99d8fb-a921-286a-8cf0-cd522e09b37c@tycho.nsa.gov>
 <20190614004600.GF18385@linux.intel.com>
 <20190614153840.GC12191@linux.intel.com>
 <CALCETrXcOQkvMHdh5DgdQ6JAgzsZCNFVEtnQz-5RbNr4vsadDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXcOQkvMHdh5DgdQ6JAgzsZCNFVEtnQz-5RbNr4vsadDQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Jun 16, 2019 at 03:14:51PM -0700, Andy Lutomirski wrote:
> On Fri, Jun 14, 2019 at 8:38 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > > Andy and/or Cedric, can you please weigh in with a concrete (and practical)
> > > use case that will break if we go with #1?  The auditing issues for #2/#3
> > > are complex to say the least...
> 
> The most significant issue I see is the following.  Consider two
> cases. First, an SGX2 enclave that dynamically allocates memory but
> doesn't execute code from dynamic memory.  Second, an SGX2 enclave
> that *does* execute code from dynamic memory.  In #1, the untrusted
> stack needs to decide whether to ALLOW_EXEC when the memory is
> allocated, which means that it either needs to assume the worst or it
> needs to know at allocation time whether the enclave ever intends to
> change the permission to X.

I'm just not convinced that folks running enclaves that can't communicate
their basic functionality will care one whit about SELinux restrictions,
i.e. will happily give EXECMOD even if it's not strictly necessary.
 
> I suppose there's a middle ground.  The driver could use model #1 for
> driver-filled pages and model #2 for dynamic pages.  I haven't tried
> to fully work it out, but I think there would be the ALLOW_READ /
> ALLOW_WRITE / ALLOW_EXEC flag for EADD-ed pages but, for EAUG-ed
> pages, there would be a different policy.  This might be as simple as
> internally having four flags instead of three:
> 
> ALLOW_READ, ALLOW_WRITE, ALLOW_EXEC: as before
> 
> ALLOW_EXEC_COND: set implicitly by the driver for EAUG.
> 
> As in #1, if you try to mmap or protect a page with neither ALLOW_EXEC
> variant, it fails (-EACCES, perhaps).  But, if you try to mmap or
> mprotect an ALLOW_EXEC_COND page with PROT_EXEC, you ask LSM for
> permission.  There is no fancy DIRTY tracking here, since it's
> reasonable to just act as though *every* ALLOW_EXEC_COND page is
> dirty.  There is no real auditing issue here, since LSM can just log
> what permission is missing.
> 
> Does this seem sensible?  It might give us the best of #1 and #2.

It would work and is easy to implement *if* SELinux ties permissions to
the process, as the SIGSTRUCT vma/file won't be available at
EAUG+mprotect().  I already have a set of patches to that effect, I'll
send 'em out in a bit.

FWIW, we still need to differentiate W->X from WX on SGX1, i.e. declaring
ALLOW_WRITE + ALLOW_EXEC shouldn't imply WX.  This is also addressed in
the forthcoming updated RFC.

> > Follow-up question, is #1 any more palatable if SELinux adds SGX specific
> > permissions and ties them to the process (instead of the vma or sigstruct)?
> 
> I'm not sure this makes a difference.  It simplifies SIGSTRUCT
> handling, which is handy.
