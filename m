Return-Path: <SRS0=a7Y8=75=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF09DC433E1
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Jun 2020 20:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8951C206F1
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Jun 2020 20:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730967AbgFPUD4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 16 Jun 2020 16:03:56 -0400
Received: from mga06.intel.com ([134.134.136.31]:28515 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728144AbgFPUD4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 16 Jun 2020 16:03:56 -0400
IronPort-SDR: FNDARWTyEfe9LQrY4f16kwE8XFPquGxRNzX/xMJceO43+kZpxi/tR4lTDJUgOG526Ahx6lE4uL
 C9wI6QFDTkPA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2020 13:03:54 -0700
IronPort-SDR: DDtB3ILQ5D5ZvvAfB50H2JP1z3+T3wWqPrujAox/m+LPMKmm7vFSCo53PeQRrlkmsFxpxdW2xD
 86yo9AaQSXDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,519,1583222400"; 
   d="scan'208";a="291183641"
Received: from gosinald-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.36.106])
  by orsmga002.jf.intel.com with ESMTP; 16 Jun 2020 13:03:42 -0700
Date:   Tue, 16 Jun 2020 23:03:40 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Darren Kenny <darren.kenny@oracle.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com
Subject: Re: [PATCH v32 12/21] x86/sgx: Add provisioning
Message-ID: <20200616200340.GB10412@linux.intel.com>
References: <20200601075218.65618-1-jarkko.sakkinen@linux.intel.com>
 <20200601075218.65618-13-jarkko.sakkinen@linux.intel.com>
 <m2img5tgtu.fsf@oracle.com>
 <20200616195450.GA10412@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616195450.GA10412@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 16, 2020 at 10:55:11PM +0300, Jarkko Sakkinen wrote:
> On Fri, Jun 05, 2020 at 09:09:49PM +0100, Darren Kenny wrote:
> > TYPO: s/devilering/delivering/?
> 
> I decided to rewrite the whole thing:
> 
>   x86/sgx: Allow a limited use of ATTRIBUTE.PROVISIONKEY for attestation
> 
>   Provisioning Certification Enclave (PCE), the root of trust for other
>   enclaves, generates a signing key from a fused key called Provisioning
>   Certification Key. PCE can then use this key to certify an attestation key
>   of a QE, e.g. we get the chain of trust down to the hardware if the Intel
>   signed PCE is used.
> 
>   To use the needed keys, ATTRIBUTE.PROVISIONKEY is required but should be
>   only allowed for those who actually need it so that only the trusted
>   parties can certify QE's.
> 
>   Obviously the attestation service should know the public key of the used
>   PCE and that way detect illegit attestation, but whitelisting the legit
>   users still adds an additional layer of defence.
> 
>   Add new device file called /dev/sgx/provision. The sole purpose of this
>   file is to provide file descriptors that act as privilege tokens to allow
>   to build enclaves with ATTRIBUTE.PROVISIONKEY set. A new ioctl called
>   SGX_IOC_ENCLAVE_SET_ATTRIBUTE is used to assign this token to an enclave.

I also refined Documentation/x86/sgx.rst based on this in my tree [*].

[*] https://github.com/jsakkine-intel/linux-sgx.git

/Jarkko
