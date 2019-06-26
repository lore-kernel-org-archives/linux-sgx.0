Return-Path: <SRS0=Ho1r=UZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 921BBC48BDA
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Jun 2019 20:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72A0C208E3
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Jun 2019 20:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfFZUjR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 26 Jun 2019 16:39:17 -0400
Received: from namei.org ([65.99.196.166]:48592 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbfFZUjP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 26 Jun 2019 16:39:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by namei.org (8.14.4/8.14.4) with ESMTP id x5QKd5NF030044;
        Wed, 26 Jun 2019 20:39:05 GMT
Date:   Thu, 27 Jun 2019 06:39:05 +1000 (AEST)
From:   James Morris <jmorris@namei.org>
To:     "Dr. Greg" <greg@enjellic.com>
cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Stephen Smalley <sds@tycho.nsa.gov>, casey.schaufler@intel.com,
        william.c.roberts@intel.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
Subject: Re: [RFC PATCH v3 09/12] LSM: x86/sgx: Introduce ->enclave_load()
 hook for Intel SGX
In-Reply-To: <20190623171626.GA25683@wind.enjellic.com>
Message-ID: <alpine.LRH.2.21.1906270637300.28132@namei.org>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com> <20190617222438.2080-10-sean.j.christopherson@intel.com> <0c4f75a0ae2fdeee6db07f3a224918f321163d56.camel@linux.intel.com> <alpine.LRH.2.21.1906200702040.28119@namei.org>
 <20190623171626.GA25683@wind.enjellic.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, 23 Jun 2019, Dr. Greg wrote:

> The most relevant and important control with respect to whether or not
> an enclave should be allowed to execute is evaluation of the
> SIGSTRUCT.  Given the trajectory that platform security is on, SGX is
> not going to be the last technology of its type nor the only
> technology that makes use of cryptographically based code provenance.
> 
> As a result, if we are content with handing an opaque pointer of a
> descriptive struture to an LSM routine, a generic hook that is tasked
> with verifying code or execution environment provenance doesn't seem
> like it would need to be technology specific nor controversial.
> 
> That leaves as the last thorny issue the question of dynamic
> allocation of memory for executable content.  As we have stated
> before, and at the outset of this note, from a security perspective
> this is only, effectively, a binary question for the platform owner as
> to whether or not the concept should be allowed.
> 
> A generic LSM hook, appropriately named, could execute that decision
> without being SGX specific.  Arguably, the hook should be named to
> indicate that it is seeking approval for allocating memory to be used
> for anonymous executable content, since that is what it would be
> effectively requesting approval for, in the case of SGX.
> 
> For completeness a third generic hook may be useful.  The purpose of
> that hook would be to verify a block of memory as being
> measured or signed for consideration as executable content.  Arguably
> that will have utility far beyond SGX.
> 
> In the case of SGX it would address the issue as to whether or not a
> block of executable content in untrusted space is eligible for
> anonymous execution.  That may be a useful security measure in order
> to provide some control over an enclave being used as a random
> execution oracle.
> 
> It obviously has no security utility against the enclave author since,
> as we have noted before, it is possible for the enclave author to
> simply pull whatever code is desired over an encrypted network
> connection.
> 
> > James Morris
> 
> Hopefully these comments are a useful basis for further discussion.

Thanks, this is helpful.

-- 
James Morris
<jmorris@namei.org>

