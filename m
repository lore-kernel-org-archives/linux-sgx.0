Return-Path: <SRS0=gKhM=SY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42FFAC10F11
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 16:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D35920896
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 16:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfDVQ05 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Apr 2019 12:26:57 -0400
Received: from wind.enjellic.com ([76.10.64.91]:58830 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbfDVQ04 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 22 Apr 2019 12:26:56 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x3MGOBMd027629;
        Mon, 22 Apr 2019 11:24:11 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x3MGOBDq027628;
        Mon, 22 Apr 2019 11:24:11 -0500
Date:   Mon, 22 Apr 2019 11:24:11 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Dr. Greg" <greg@enjellic.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
Message-ID: <20190422162411.GA27389@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <e1478f70-7e44-6e3e-2aaf-1b12a96328ed@fortanix.com> <2AE80EA3-799E-4808-BBE4-3872F425BCF8@amacapital.net> <49b28ca1-6e66-87d9-2202-84c58f13fb99@fortanix.com> <444537E3-4156-41FB-83CA-57C5B660523F@amacapital.net> <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com> <alpine.DEB.2.21.1904192337160.3174@nanos.tec.linutronix.de> <5854e66a-950e-1b12-5393-d9cdd15367dc@fortanix.com> <alpine.DEB.2.21.1904200727410.3174@nanos.tec.linutronix.de> <20190420160247.GA17291@wind.enjellic.com> <20190422150119.GA1236@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190422150119.GA1236@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Mon, 22 Apr 2019 11:24:12 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 22, 2019 at 08:01:19AM -0700, Sean Christopherson wrote:

Good morning to everyone, I hope the week is starting well.

> On Sat, Apr 20, 2019 at 11:02:47AM -0500, Dr. Greg wrote:
> > We understand and support the need for the LSM to trap these
> > events, but what does LSM provenance mean if the platform is
> > compromised?  That is, technically, the target application for SGX
> > technology.

> No, it's not.  Protecting the kernel/platform from a malicious
> entity is outside the scope of SGX.

You must have misinterpreted my statement, providing security
guarantees in the face of a compromised platform is exactly what SGX
was designed to do and is how Intel is marketing the technology.

From the first paragraph (Introduction) in the following document:

https://software.intel.com/sites/default/files/managed/50/8c/Intel-SGX-Product-Brief.pdf

"Intel Software Guard Extensions (Intel SGX) protects selected code
and data from disclosure or modification.  Developers can partition
their application into CPU hardened 'enclaves' or protected areas of
execution that increase security even on compromised platforms".

In addition, one of the major use cases for this technology is the
ability to push data and application code up onto cloud platforms with
a guarantee that not even the platform owner or administrators can
compromise the integrity or confidentiality of the code and data.

As I've noted before, from an OS driver perspective, security and
privacy models which are dependent on an uncompromised platform and
user privileges are inconsistent with the SGX security architecture.
Doing SGX right is about applying cryptographically defined provenance
and integrity models.

Our autonomous introspection technology uses SGX to protect the
platform at large but we are unique with respect to how the technology
is being applied.

Have a good day.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"You and Uncle Pete drank the whole thing?  That was a $250.00 bottle
 of whisky.

 Yeah, it was good."
                                -- Rick Engen
                                   Resurrection.
