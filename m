Return-Path: <SRS0=/KO+=TU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_DR,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C09CFC04E87
	for <linux-sgx@archiver.kernel.org>; Mon, 20 May 2019 09:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 965F620675
	for <linux-sgx@archiver.kernel.org>; Mon, 20 May 2019 09:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730628AbfETJlv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 20 May 2019 05:41:51 -0400
Received: from wind.enjellic.com ([76.10.64.91]:32972 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726126AbfETJlu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 20 May 2019 05:41:50 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x4K9cIa4007978;
        Mon, 20 May 2019 04:38:18 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x4K9cFlE007977;
        Mon, 20 May 2019 04:38:15 -0500
Date:   Mon, 20 May 2019 04:38:15 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     James Morris <jmorris@namei.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Message-ID: <20190520093815.GA7187@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com> <20190514204527.GC1977@linux.intel.com> <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com> <20190515013031.GF1977@linux.intel.com> <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com> <alpine.LRH.2.21.1905160543070.19802@namei.org> <CALCETrX_Q6qwNRNF0TL2tgfm1j6DKLX7NVHHmWbMFtk3WnHDKw@mail.gmail.com> <alpine.LRH.2.21.1905160844130.29250@namei.org> <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com> <alpine.LRH.2.21.1905161716460.23647@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.1905161716460.23647@namei.org>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Mon, 20 May 2019 04:38:18 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 16, 2019 at 05:24:33PM +1000, James Morris wrote:

Good morning, I hope everyone had a pleasant weekend.

James, I believe the last time our paths crossed was at the Linux
Security Summit in Seattle, I trust you have been well since then.

> On Wed, 15 May 2019, Andy Lutomirski wrote:
> 
> > On Wed, May 15, 2019 at 3:46 PM James Morris <jmorris@namei.org> wrote:
> > >
> > > You could try user.sigstruct, which does not require any privs.
> > >
> > 
> > I don't think I understand your proposal.  What file would this
> > attribute be on?  What would consume it?

> It would be on the enclave file, so you keep the sigstruct bound to
> it, rather than needing a separate file to manage.  It would
> simplify any LSM policy check.
>
> It would be consumed by (I guess) the SGX_INIT_THE_ENCLAVE ioctl in your 
> example, instead of having a 2nd fd.

I've watched this discussion regarding LSM, sigstructs and file
descriptors with some fascination, since all of this infrastructure
already exists and should be well understood by anyone who has been
active in SGX runtime development.  There would thus seem to be a
disconnect between SGX driver developers and the consumers of the
services of the driver.

The existing enclave format, codified by the silo within Intel that is
responsible for the existing SDK/PSW, implements a notes section
stored inside a standard ELF shared library image.  The notes section
contains a significant amount of metadata that is used to direct the
instantiation of what will be the initialized enclave image.  Said
metadata includes a copy of the sigstruct that was generated when the
enclave was signed, which is the event that triggers metadata
generation.

All of this means that any enclave that gets loaded effectively
triggers both LSM and IMA checks.

James, if you remember, the paper that we presented in Seattle
described the initial implementation of an extension to the Linux IMA
infrastructure that tracks whether or not processes can be 'trusted'.
That work has gone on to include running the trust modeling and
disciplining engine inside of a namespace specific SGX enclave.  We
would be happy to make available execution trajectory logs that
clearly document IMA and LSM checks being conducted on enclaves.

There is a strong probability that we will be maintaining and
supporting a modified version of whatever driver that goes upstream.
In support of this we are putting together a white paper discussing
security architecture concerns inherent in an SGX driver.  With the
intent of avoiding LKML verbosity we will post a URL to the paper when
it is available if there is interest.

The issue of EDMM has already come up, suffice it to say that EDMM
makes LSM inspection of enclave content, while desirable, largely
irrelevant from a security perspective.

> James Morris

Best wishes for a productive week.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686            EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"If you plugged up your nose and mouth right before you sneezed, would
 the sneeze go out your ears or would your head explode?  Either way I'm
 afraid to try."
                                -- Nick Kean
