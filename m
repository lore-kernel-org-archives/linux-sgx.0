Return-Path: <SRS0=/aec=US=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46EC0C43613
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 21:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2961D2085A
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 21:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbfFSVOH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Jun 2019 17:14:07 -0400
Received: from namei.org ([65.99.196.166]:46494 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730449AbfFSVOG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Jun 2019 17:14:06 -0400
Received: from localhost (localhost [127.0.0.1])
        by namei.org (8.14.4/8.14.4) with ESMTP id x5JLDoim030697;
        Wed, 19 Jun 2019 21:13:50 GMT
Date:   Thu, 20 Jun 2019 07:13:50 +1000 (AEST)
From:   James Morris <jmorris@namei.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>, casey.schaufler@intel.com,
        william.c.roberts@intel.com
Subject: Re: [RFC PATCH v3 09/12] LSM: x86/sgx: Introduce ->enclave_load()
 hook for Intel SGX
In-Reply-To: <0c4f75a0ae2fdeee6db07f3a224918f321163d56.camel@linux.intel.com>
Message-ID: <alpine.LRH.2.21.1906200702040.28119@namei.org>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>  <20190617222438.2080-10-sean.j.christopherson@intel.com> <0c4f75a0ae2fdeee6db07f3a224918f321163d56.camel@linux.intel.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 19 Jun 2019, Jarkko Sakkinen wrote:

> Can LSM callbacks ever non-generic when it comes to hardware? This is
> the very first time I ever see such callbacks being introduced.
> 
> I suspect that from maintainers perspective, accepting such changes for
> Intel hardware, could open a pandoras box.

If there's a major distro/userbase committing to ship with these hooks 
enabled via a supported in-tree LSM, the case for inclusion is clear.

If the hooks could be generalized beyond just SGX, that would be ideal, 
but it's not clear if that's feasible.

-- 
James Morris
<jmorris@namei.org>

