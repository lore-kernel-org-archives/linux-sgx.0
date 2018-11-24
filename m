Return-Path: <SRS0=WnqF=OD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC70C43610
	for <linux-sgx@archiver.kernel.org>; Sat, 24 Nov 2018 19:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B1ED20868
	for <linux-sgx@archiver.kernel.org>; Sat, 24 Nov 2018 19:25:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B1ED20868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=enjellic.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbeKYGOq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 25 Nov 2018 01:14:46 -0500
Received: from wind.enjellic.com ([76.10.64.91]:55086 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbeKYGOq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 25 Nov 2018 01:14:46 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id wAOJOuRT012273;
        Sat, 24 Nov 2018 13:24:56 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id wAOJOsKe012272;
        Sat, 24 Nov 2018 13:24:54 -0600
Date:   Sat, 24 Nov 2018 13:24:54 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com,
        haitao.huang@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>, andy@infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181124192454.GA12149@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com> <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com> <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com> <20181120111508.GA26127@wind.enjellic.com> <20181124161521.GB30310@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181124161521.GB30310@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sat, 24 Nov 2018 13:24:56 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Nov 24, 2018 at 08:15:21AM -0800, Jarkko Sakkinen wrote:

> On Tue, Nov 20, 2018 at 05:15:08AM -0600, Dr. Greg wrote:
> > Malware would not necessarily need the Intel attestation service.
> > Once access to the PROVISION bit is available, malware teams could
> > simply build their own attestation service.

> AFAIK not possible as they wouldn't have access to the root
> provisioning key. Can be confirmed from the SDM's key derivation
> table (41-56).

What provisioning and attestation is all about is establishing an
identity binding for a platform in question.  The standard Intel
service binds the identity of a platform to an EPID private key.

With access to the SGX_FLAGS_PROVISION_BIT an enclave can generate a
perpetual identity for a platform based on the identity modulus
signature (MRSIGNER) of the key that signs the signature structure of
the enclave.  Without access to the root provisioning key a security
quorum or group has to be implemented via a subscription or enrollment
model but that is arguably not much of an obstacle.

That is pretty much the way standard botware works now.

Without provisions for cryptographically secure authorization and
policy enforcement in the driver, we will be creating infrastructure
for a new generation of botware/malware whose mothership will know
that a participating platform is running with full confidentiality and
integrity protections.

> /Jarkko

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Remember that when you take down the fishhouse you can't put
 the minnows back into the lake, so throw them out on the ice.
 Make sure you stomp on any of the live ones so they don't suffer."
                                -- Fritz Wettstein
                                   At the lake
