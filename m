Return-Path: <SRS0=cz4p=SV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E55C282DF
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 18:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E07AF20449
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 18:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfDSSeD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:34:03 -0400
Received: from wind.enjellic.com ([76.10.64.91]:58564 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728285AbfDSSeD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 19 Apr 2019 14:34:03 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x3JEHZjQ002435;
        Fri, 19 Apr 2019 09:17:35 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x3JEHWMW002434;
        Fri, 19 Apr 2019 09:17:32 -0500
Date:   Fri, 19 Apr 2019 09:17:32 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
Message-ID: <20190419141732.GA2269@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com> <20190418171059.GA20819@wind.enjellic.com> <09ebfa1d-c03d-c1fe-ff0f-d99287b6ec3c@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09ebfa1d-c03d-c1fe-ff0f-d99287b6ec3c@intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Fri, 19 Apr 2019 09:17:35 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 18, 2019 at 11:01:00AM -0700, Dave Hansen wrote:

Good morning to everyone.

> On 4/18/19 10:10 AM, Dr. Greg wrote:
> > Both the current controls for enclave access to the PROVISION
> > attribute and the security controls that are being proposed to emerge
> > for the driver, sometime in the future, suffer from being dependent on
> > discretionary access controls, ie. file privileges, that can be
> > defeated by a privilege escalation attack.  Those of us building
> > architectures on top of this technology have a need to certify that an
> > application will provide security contracts robust in the face of a
> > privilege escalation event or platform compromise.

> I'm not following.
>
> Are you saying that the implementation here is too permissive with
> the enclaves that are allowed to run?  Because it's too permissive,
> this leaves us vulnerable to SGX being used to conceal a cache
> attack?

I believe that would be the conclusion of a dispassionate observer who
has followed this conversation and read the paper that I provided a
link to.

For the benefit of those with a disinclination to read, particularly
16 page research papers, the following link provides a summary of the
issues at hand.

https://www.securityweek.com/intel-sgx-can-be-abused-hide-advanced-malware-researchers

Of relevance to this conversation is Intel Security's official
response to the paper, which is as follows:

"The value of Intel SGX is to execute code in a protected enclave;
however, Intel SGX does not guarantee that the code executed in the
enclave is from a trusted source.  In all cases, we recommend
utilizing programs, files, apps and plugins from trusted sources,"
Intel said.

The issue is not as much the ABI break but the following facts that
are at hand:

1.) The proposed mainline driver offers no cryptographic or
architecturally relevant security controls for ensuring that enclaves
are from a trusted source.

2.) Based on Andy's comments there may be a disinclination to ever
provide those controls.

3.) The approach we propose addresses these issues while imposing no
functional limitations on how Linux platform owners can use enclave
technology.

Seems like a win.

There you go, one sentence replies.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Laugh now but you won't be laughing when we find you laying on the
 side of the road dead."
                                -- Betty Wettstein
                                   At the Lake
