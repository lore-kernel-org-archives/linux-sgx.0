Return-Path: <SRS0=wmvE=UL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_DR,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A3BC31E46
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jun 2019 09:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F717208C2
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jun 2019 09:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408843AbfFLJeH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Jun 2019 05:34:07 -0400
Received: from wind.enjellic.com ([76.10.64.91]:35126 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408577AbfFLJeH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 12 Jun 2019 05:34:07 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x5C9WOWI024604;
        Wed, 12 Jun 2019 04:32:24 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x5C9WLgm024603;
        Wed, 12 Jun 2019 04:32:21 -0500
Date:   Wed, 12 Jun 2019 04:32:21 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        Cedric Xing <cedric.xing@intel.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        jarkko.sakkinen@linux.intel.com, luto@kernel.org,
        jmorris@namei.org, serge@hallyn.com, paul@paul-moore.com,
        eparis@parisplace.org, jethro@fortanix.com, dave.hansen@intel.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, nhorman@redhat.com,
        pmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, kai.svahn@intel.com,
        bp@alien8.de, josh@joshtriplett.org, kai.huang@intel.com,
        rientjes@google.com, william.c.roberts@intel.com,
        philip.b.tricca@intel.com
Subject: Re: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in SELinux
Message-ID: <20190612093221.GA24188@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <cover.1560131039.git.cedric.xing@intel.com> <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com> <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov> <20190611220243.GB3416@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611220243.GB3416@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Wed, 12 Jun 2019 04:32:24 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 11, 2019 at 03:02:43PM -0700, Sean Christopherson wrote:

Good morning, I hope the week is proceeding well for everyone.

> On Tue, Jun 11, 2019 at 09:40:25AM -0400, Stephen Smalley wrote:
> > I haven't looked at this code closely, but it feels like a lot of
> > SGX-specific logic embedded into SELinux that will have to be repeated or
> > reused for every security module.  Does SGX not track this state itself?

> SGX does track equivalent state.
> 
> There are three proposals on the table (I think):
> 
>   1. Require userspace to explicitly specificy (maximal) enclave page
>      permissions at build time.  The enclave page permissions are provided
>      to, and checked by, LSMs at enclave build time.
> 
>      Pros: Low-complexity kernel implementation, straightforward auditing
>      Cons: Sullies the SGX UAPI to some extent, may increase complexity of
>            SGX2 enclave loaders.
> 
>   2. Pre-check LSM permissions and dynamically track mappings to enclave
>      pages, e.g. add an SGX mprotect() hook to restrict W->X and WX
>      based on the pre-checked permissions.
> 
>      Pros: Does not impact SGX UAPI, medium kernel complexity
>      Cons: Auditing is complex/weird, requires taking enclave-specific
>            lock during mprotect() to query/update tracking.
> 
>   3. Implement LSM hooks in SGX to allow LSMs to track enclave regions
>      from cradle to grave, but otherwise defer everything to LSMs.
> 
>      Pros: Does not impact SGX UAPI, maximum flexibility, precise auditing
>      Cons: Most complex and "heaviest" kernel implementation of the three,
>            pushes more SGX details into LSMs.
> 
> My RFC series[1] implements #1.  My understanding is that Andy (Lutomirski)
> prefers #2.  Cedric's RFC series implements #3.
> 
> Perhaps the easiest way to make forward progress is to rule out the
> options we absolutely *don't* want by focusing on the potentially blocking
> issue with each option:
>
>   #1 - SGX UAPI funkiness
> 
>   #2 - Auditing complexity, potential enclave lock contention
> 
>   #3 - Pushing SGX details into LSMs and complexity of kernel implementation

At the risk of repeating myself, I believe the issue that has not
received full clarity is that, for a security relevant solution, there
has to be two separate aspects of LSM coverage for SGX.  I believe
that a high level review of the requirements may assist in selection
of a course of action for the driver.

The first aspect of LSM control has been covered extensively and that
is the notion of implementing control over the ability of a user
identity to request some cohort of page privileges.  The cohort of
obvious concern is the ability of a page to possess both WRITE and
EXECUTE privileges at sometime during its lifetime.

Given that SGX2 support is the ultimate and necesary goal for this
driver, the selected proposal should be the one that gives the most
simplistic application of this policy.  As I have noted previously,
once SGX2 becomes available, the only relevant security control that
can be realized with this type of LSM support is whether or not the
platform owner wishes to limit access by a user identity to the
ability to dynamically load code in enclave context.

With SGX2 we will, by necessity, have to admit the notion that a
platform owner will not have any effective visibility into code that
is loaded and executed, since it can come in over a secured network
connection in an enclave security context.  This advocates for the
simplest approach possible to providing some type of regulation to any
form of WX page access.

Current state of the art, and there doesn't appear to be a reason to
change this, is to package an enclave in the form of an ELF shared
library.  It seems straight forward to inherit and act on page
privileges from the privileges specified on the ELF sections that are
loaded.  Loaders will have a file descriptor available so an mmap of
the incoming page with the specified privileges should trigger the
required LSM interventions and tie them to a specific enclave.

The current enclave 'standard' also uses layout metadata, stored in a
special .notes section of the shared image, to direct a loader with
respect to construction of the enclave stack, heap, TCS and other
miscellaneous regions not directly coded by the ELF TEXT sections.  It
seems straight forward to extend this paradigm to declare region(s) of
an enclave that are eligible to be generated at runtime (EAUG'ed) with
the RWX protections needed to support dynamically loaded code.

If an enclave wishes to support this functionality, it would seem
straight forward to require an enclave to provide a single zero page
which the loader will mmap with those protections in order to trigger
the desired LSM checks against that specific enclave.

The simplest driver approach that achieves the desired introspection
of permissions in the described framework will implement as much LSM
security as is possible with SGX technology and with minimal
disruption to the existing SGX software eco-system.

This leaves the second aspect of LSM security and that is the ability
to inspect and act on the initialized characteristics of the enclave.
This is the aspect of SGX LSM functionality that has not been clearly
called out.

All that is needed here is an LSM hook that gets handed a pointer to
the signature structure (SIGSTRUCT) that is passed to the EINIT ioctl.
If the SIGSTRUCT does not match the proposed enclave image that the
processor has computed secondary to the enclave image creation process
the enclave will not initialize, so all that is needed is for an LSM
to be allowed to interpret and act on the characteristics defined in
that structure before the enclave is actually initialized.

As we have now collectively demonstrated, it is easy to get lost in
minutia with respect to all of this.  I believe if we can focus on a
solution that implements what I have discussed above we will achieve
as much as can be achieved with respect to platform security for SGX
systems.

Best wishes for a productive remainder of the week.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686            EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Nullum magnum ingenium sine mixtura dementiae fuit."
        (There is no great genius without some touch of madness.)
                                -- Seneca
