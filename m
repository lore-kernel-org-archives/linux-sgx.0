Return-Path: <SRS0=HOZE=O4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00286C43387
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Dec 2018 14:46:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9E1121841
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Dec 2018 14:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbeLSOqr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Dec 2018 09:46:47 -0500
Received: from wind.enjellic.com ([76.10.64.91]:57640 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727943AbeLSOqr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Dec 2018 09:46:47 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id wBJEhj5k031580;
        Wed, 19 Dec 2018 08:43:45 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id wBJEhhv3031579;
        Wed, 19 Dec 2018 08:43:43 -0600
Date:   Wed, 19 Dec 2018 08:43:43 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: x86/sgx: uapi change proposal
Message-ID: <20181219144343.GA31189@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20181214215729.4221-1-sean.j.christopherson@intel.com> <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com> <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Wed, 19 Dec 2018 08:43:45 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 19, 2018 at 08:41:12AM +0000, Jethro Beekman wrote:

Good morning, I everyone is weathering the pre-holiday season well.

> On 2018-12-19 13:28, Jarkko Sakkinen wrote:
> > * @eclave_fd:		file handle to the enclave address space
> > * @attribute_fd:	file handle of the attribute file in the securityfs
> > */
> >struct sgx_enclave_set_attribute {
> >	__u64	enclave_fd;
> >	__u64	attribute_fd;
> >};

> What is this for?

I believe it is a silent response to the issues we were prosecuting
4-5 weeks ago, regarding the requirement for an SGX driver on an FLC
hardware platform to have some semblance of policy management to be
relevant from a security/privacy perspective.  It would have certainly
been collegial to include a reference to our discussions and concerns
in the changelog.

See 364f68f5a3c in Jarkko's next/master.

The changeset addresses enclave access to the PROVISION key but is
still insufficient to deliver guarantees that are consistent with the
SGX security model.  In order to achieve that, policy management needs
to embrace the use of MRSIGNER values, which is what our SFLC patchset
uses.

The noted changeset actually implements most of the 'kernel bloat'
that our SFLC patchset needs to bolt onto.

As of yesterday afternoon next/master still won't initialize a
non-trivial enclave.  Since there now appears to be a wholesale change
in the driver architecture and UAPI we are sitting on the sidelines
waiting for an indication all of that has some hope of working before
we introduce our approach.

Part of SFLC won't be popular but it is driven by clients who are
actually paying for SGX security engineering and architectures.

> Jethro Beekman | Fortanix

Best wishes for a pleasant holiday season to everyone.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Politics is the business of getting power and privilege without possessing
 merit."
                                -- P.J. O'Rourke
