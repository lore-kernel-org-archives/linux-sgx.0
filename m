Return-Path: <SRS0=PKbn=UR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_DR,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA3EC31E5B
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Jun 2019 15:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2124220873
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Jun 2019 15:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729750AbfFRPmB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Jun 2019 11:42:01 -0400
Received: from wind.enjellic.com ([76.10.64.91]:35716 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729349AbfFRPmA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Jun 2019 11:42:00 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x5IFegEV006176;
        Tue, 18 Jun 2019 10:40:42 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x5IFeepQ006175;
        Tue, 18 Jun 2019 10:40:40 -0500
Date:   Tue, 18 Jun 2019 10:40:40 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
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
Subject: Re: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in SELinux
Message-ID: <20190618154040.GA4603@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <cover.1560131039.git.cedric.xing@intel.com> <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com> <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov> <20190611220243.GB3416@linux.intel.com> <8d99d8fb-a921-286a-8cf0-cd522e09b37c@tycho.nsa.gov> <20190614004600.GF18385@linux.intel.com> <20190614153840.GC12191@linux.intel.com> <CALCETrXcOQkvMHdh5DgdQ6JAgzsZCNFVEtnQz-5RbNr4vsadDQ@mail.gmail.com> <20190617164915.GA25085@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617164915.GA25085@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Tue, 18 Jun 2019 10:40:42 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 17, 2019 at 09:49:15AM -0700, Sean Christopherson wrote:

Good morning to everyone.

> On Sun, Jun 16, 2019 at 03:14:51PM -0700, Andy Lutomirski wrote:
> > The most significant issue I see is the following.  Consider two
> > cases. First, an SGX2 enclave that dynamically allocates memory but
> > doesn't execute code from dynamic memory.  Second, an SGX2 enclave
> > that *does* execute code from dynamic memory.  In #1, the untrusted
> > stack needs to decide whether to ALLOW_EXEC when the memory is
> > allocated, which means that it either needs to assume the worst or it
> > needs to know at allocation time whether the enclave ever intends to
> > change the permission to X.

> I'm just not convinced that folks running enclaves that can't
> communicate their basic functionality will care one whit about
> SELinux restrictions, i.e. will happily give EXECMOD even if it's
> not strictly necessary.

Hence the comments in my mail from last Friday.

It seems to us that the path forward is to require the enclave
author/signer to express their intent to implement executable dynamic
memory, see below.

> > I suppose there's a middle ground.  The driver could use model #1 for
> > driver-filled pages and model #2 for dynamic pages.  I haven't tried
> > to fully work it out, but I think there would be the ALLOW_READ /
> > ALLOW_WRITE / ALLOW_EXEC flag for EADD-ed pages but, for EAUG-ed
> > pages, there would be a different policy.  This might be as simple as
> > internally having four flags instead of three:
> > 
> > ALLOW_READ, ALLOW_WRITE, ALLOW_EXEC: as before
> > 
> > ALLOW_EXEC_COND: set implicitly by the driver for EAUG.
> > 
> > As in #1, if you try to mmap or protect a page with neither ALLOW_EXEC
> > variant, it fails (-EACCES, perhaps).  But, if you try to mmap or
> > mprotect an ALLOW_EXEC_COND page with PROT_EXEC, you ask LSM for
> > permission.  There is no fancy DIRTY tracking here, since it's
> > reasonable to just act as though *every* ALLOW_EXEC_COND page is
> > dirty.  There is no real auditing issue here, since LSM can just log
> > what permission is missing.
> > 
> > Does this seem sensible?  It might give us the best of #1 and #2.

> It would work and is easy to implement *if* SELinux ties permissions
> to the process, as the SIGSTRUCT vma/file won't be available at
> EAUG+mprotect().  I already have a set of patches to that effect,
> I'll send 'em out in a bit.

The VMA that is crafted from the enclave file is going to exist for
the life of the enclave.  If the intent to use executable dynamic
memory is specified when the enclave image is being built, or as a
component of enclave initialization, the driver is in a position to
log/deny a request to EAUG+mprotect whenever it occurs.  The sensitive
criteria would seem to be any request for dynamically allocated memory
with executable status.

The potential security impact of dynamically executable content is
something that is dependent on the enclave author rather then the
context of execution that is requesting pages to be allocated for such
purposes.  There is going to be an LSM hook to evaluate the SIGSTRUCT
at the time of EINIT, so all of the necessary information is there to
make a decision on whether or not to flag the VMA as being allowed to
support dynamically executable content.

It doesn't seem like an onerous requirement for this information to be
specified in the enclave metadata.  For optimum security, one could
perhaps argue that the ability to implement dynamic memory should have
been a specifiable attribute of the enclave, similar to the debug,
launch and provisioning attributes.

As we have indicated in the past, once the enclave is initialized with
permissions for dynamically executable content, the platform is
completely dependent on the security intentions of the author of the
enclave.  Given that, the notion of enduring significant LSM
complexity does not seem to be justified.

Which opens up another set of security implications to discuss but we will let
those lie for the moment.

Have a good day.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686            EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"More people are killed every year by pigs than by sharks, which shows
 you how good we are at evaluating risk."
                                -- Bruce Schneier
                                   Beyond Fear
