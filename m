Return-Path: <SRS0=3ZKM=VA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB4BC06513
	for <linux-sgx@archiver.kernel.org>; Wed,  3 Jul 2019 09:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF2FB218A3
	for <linux-sgx@archiver.kernel.org>; Wed,  3 Jul 2019 09:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfGCJr0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 3 Jul 2019 05:47:26 -0400
Received: from wind.enjellic.com ([76.10.64.91]:37002 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbfGCJr0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 3 Jul 2019 05:47:26 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x639krAT029727;
        Wed, 3 Jul 2019 04:46:53 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x639kp8l029726;
        Wed, 3 Jul 2019 04:46:51 -0500
Date:   Wed, 3 Jul 2019 04:46:51 -0500
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
Message-ID: <20190703094651.GA29601@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <960B34DE67B9E140824F1DCDEC400C0F6551B975@ORSMSX116.amr.corp.intel.com> <f6f16990-0291-c530-61dd-dcd26525285c@schaufler-ca.com> <CAB9W1A1RpM_9D_49E1VauuKE1tL=TyfeATomv47HX4FONnjA4A@mail.gmail.com> <18833f2e-9d18-1f39-6bc5-9242910ab25c@schaufler-ca.com> <960B34DE67B9E140824F1DCDEC400C0F6551D585@ORSMSX116.amr.corp.intel.com> <f59529e4-6cc8-2405-d7db-2519727f9a80@schaufler-ca.com> <960B34DE67B9E140824F1DCDEC400C0F6551D7F7@ORSMSX116.amr.corp.intel.com> <63c92ab6-dc8d-826b-b8bf-05ad262f06e4@schaufler-ca.com> <960B34DE67B9E140824F1DCDEC400C0F6551DBF7@ORSMSX116.amr.corp.intel.com> <9e45df1b-3aac-e851-4ef2-5b262f5139bd@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e45df1b-3aac-e851-4ef2-5b262f5139bd@schaufler-ca.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Wed, 03 Jul 2019 04:46:53 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jul 02, 2019 at 08:44:40AM -0700, Casey Schaufler wrote:

Good morning, I hope this note finds the week going well for everyone.

> On 7/2/2019 12:42 AM, Xing, Cedric wrote:
> > ...
> > Guess this discussion will never end if we don't get into
> > code. Guess it'd be more productive to talk over phone then come back
> > to this thread with a conclusion. Will that be ok with you?

> I don't think that a phone call is going to help. Talking code
> issues tends to muddle them in my brain. If you can give me a few
> days I will propose a rough version of how I think your code should
> be integrated into the LSM environment. I'm spending more time
> trying (unsuccessfully :( ) to discribe the issues in English than
> it will probably take in C.

While Casey is off writing his rosetta stone, let me suggest that the
most important thing we need to do is to take a little time, step back
and look at the big picture with respect to what we are trying to
accomplish and if we are going about it in a way that makes any sense
from an engineering perspective.

This conversation shouldn't be about SGX, it should be about the best
way for the kernel/LSM to discipline a Trusted Execution Environment
(TEE).  As I have noted previously, a TEE is a 'blackbox' that, by
design, is intended to allow execution of code and processing of data
in a manner that is resistant to manipulation or inspection by
untrusted userspace, the kernel and/or the hardware itself.

Given that fact, if we are to be intellectually honest, we need to ask
ourselves how effective we believe we can be in controlling any TEE
with kernel based mechanisms.  This is particularly the case if the
author of any code running in the TEE has adversarial intent.

Here is the list of controls that we believe an LSM can, effectively,
implement against a TEE:

1.) Code provenance and origin.

2.) Cryptographic verification of dynamically executable content.

2.) The ability of a TEE to implement anonymous executable content.

If people are in agreement with this concept, it is difficult to
understand why we should be implementing complex state machines and
the like, whether it is in the driver or the LSM.  Security code has
to be measured with a metric of effectiveness, otherwise we are
engaging in security theater.

I believe that if we were using this lens, we would already have a
mainline SGX driver, since we seem to have most of the needed LSM
infrastructure and any additional functionality would be a straight
forward implementation.  Most importantly, the infrastructure would
not be SGX specific, which would seem to be a desirable political
concept.

If we are not willing to engage in this discussion we are going to end
up with a quasi-technology specific solution that isn't implementing
any relevant security guarantees.

FWIW, we wouldn't even be having this, now lengthy discussion, if I
wouldn't have aggressively advocated, starting last November, that an
SGX driver needed some form of execution control if there was a desire
for the technology to not pose a security risk to the platform.  So
humor me a little bit.... :-)

Best wishes for a productive remainder of the week to everyone.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker
IDfusion, LLC
4206 N. 19th Ave.           Implementing measured information privacy
Fargo, ND  58102            and integrity architectures.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@idfusion.net
------------------------------------------------------------------------------
"... remember that innovation is saying 'no' to 1000 things."
