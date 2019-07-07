Return-Path: <SRS0=QGFU=VE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D34DEC48BDC
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Jul 2019 13:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E620206A3
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Jul 2019 13:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfGGNbA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 7 Jul 2019 09:31:00 -0400
Received: from wind.enjellic.com ([76.10.64.91]:37324 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbfGGNbA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 7 Jul 2019 09:31:00 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x67DUQYt004625;
        Sun, 7 Jul 2019 08:30:26 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x67DUNRn004624;
        Sun, 7 Jul 2019 08:30:23 -0500
Date:   Sun, 7 Jul 2019 08:30:23 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Stephen Smalley <stephen.smalley@gmail.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Message-ID: <20190707133023.GA4521@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <CAB9W1A1RpM_9D_49E1VauuKE1tL=TyfeATomv47HX4FONnjA4A@mail.gmail.com> <18833f2e-9d18-1f39-6bc5-9242910ab25c@schaufler-ca.com> <960B34DE67B9E140824F1DCDEC400C0F6551D585@ORSMSX116.amr.corp.intel.com> <f59529e4-6cc8-2405-d7db-2519727f9a80@schaufler-ca.com> <960B34DE67B9E140824F1DCDEC400C0F6551D7F7@ORSMSX116.amr.corp.intel.com> <63c92ab6-dc8d-826b-b8bf-05ad262f06e4@schaufler-ca.com> <960B34DE67B9E140824F1DCDEC400C0F6551DBF7@ORSMSX116.amr.corp.intel.com> <9e45df1b-3aac-e851-4ef2-5b262f5139bd@schaufler-ca.com> <20190703094651.GA29601@wind.enjellic.com> <012fc47d-4e9d-3398-0d9d-d9298a758c8d@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <012fc47d-4e9d-3398-0d9d-d9298a758c8d@schaufler-ca.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sun, 07 Jul 2019 08:30:26 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jul 03, 2019 at 08:32:10AM -0700, Casey Schaufler wrote:

Good morning, I hope the weekend has been enjoyable for everyone.

> >> On 7/2/2019 12:42 AM, Xing, Cedric wrote:
> >>> ...
> >>> Guess this discussion will never end if we don't get into
> >>> code. Guess it'd be more productive to talk over phone then come back
> >>> to this thread with a conclusion. Will that be ok with you?
> >> I don't think that a phone call is going to help. Talking code
> >> issues tends to muddle them in my brain. If you can give me a few
> >> days I will propose a rough version of how I think your code should
> >> be integrated into the LSM environment. I'm spending more time
> >> trying (unsuccessfully :( ) to discribe the issues in English than
> >> it will probably take in C.
> > While Casey is off writing his rosetta stone,

> I'd hardly call it that. More of an effort to round the corners on
> the square peg. And Cedric has some ideas on how to approach that.

Should we infer from this comment that, of the two competing
strategies, Cedric's is the favored architecture?

> > let me suggest that the
> > most important thing we need to do is to take a little time, step back
> > and look at the big picture with respect to what we are trying to
> > accomplish and if we are going about it in a way that makes any sense
> > from an engineering perspective.
> >
> > This conversation shouldn't be about SGX, it should be about the best
> > way for the kernel/LSM to discipline a Trusted Execution Environment
> > (TEE).  As I have noted previously, a TEE is a 'blackbox' that, by
> > design, is intended to allow execution of code and processing of data
> > in a manner that is resistant to manipulation or inspection by
> > untrusted userspace, the kernel and/or the hardware itself.
> >
> > Given that fact, if we are to be intellectually honest, we need to ask
> > ourselves how effective we believe we can be in controlling any TEE
> > with kernel based mechanisms.  This is particularly the case if the
> > author of any code running in the TEE has adversarial intent.
> >
> > Here is the list of controls that we believe an LSM can, effectively,
> > implement against a TEE:
> >
> > 1.) Code provenance and origin.
> >
> > 2.) Cryptographic verification of dynamically executable content.
> >
> > 2.) The ability of a TEE to implement anonymous executable content.
> >
> > If people are in agreement with this concept, it is difficult to
> > understand why we should be implementing complex state machines and
> > the like, whether it is in the driver or the LSM.  Security code has
> > to be measured with a metric of effectiveness, otherwise we are
> > engaging in security theater.
> >
> > I believe that if we were using this lens, we would already have a
> > mainline SGX driver, since we seem to have most of the needed LSM
> > infrastructure and any additional functionality would be a straight
> > forward implementation.  Most importantly, the infrastructure would
> > not be SGX specific, which would seem to be a desirable political
> > concept.

> Generality introduced in the absence of multiple instances
> often results in unnecessary complexity, unused interfaces
> and feature compromise. Guessing what other TEE systems might
> do, and constraining SGX to those models (or the other way around)
> is a well established road to ruin. The LSM infrastructure is
> a fine example. For the first ten years the "general" mechanism
> had a single user. I'd say to hold off on the general until there
> is more experience with the specific. It's easier to construct
> a general mechanism around things that work than to fit things
> that need to work into some preconceived notion of generality. 

All well taken points from an implementation perspective, but they
elide the point I was trying to make.  Which is the fact that without
any semblance of a discussion regarding the requirements needed to
implement a security architecture around the concept of a TEE, this
entire process, despite Cedric's well intentioned efforts, amounts to
pounding a square solution into the round hole of a security problem.

Which, as I noted in my e-mail, is tantamount to security theater.

Everyone wants to see this driver upstream.  If we would have had a
reasoned discussion regarding what it means to implement proper
controls around a TEE, when we started to bring these issues forward
last November, we could have possibly been on the road to having a
driver with reasoned security controls and one that actually delivers
the security guarantees the hardware was designed to deliver.

Best wishes for a productive week to everyone.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686            EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Any intelligent fool can make things bigger and more complex... It
 takes a touch of genius - and a lot of courage to move in the opposite
 direction."
                                -- Albert Einstein
