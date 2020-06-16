Return-Path: <SRS0=a7Y8=75=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C36C433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Jun 2020 19:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EC3E207C4
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Jun 2020 19:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730183AbgFPTzN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 16 Jun 2020 15:55:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:48548 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728144AbgFPTzM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 16 Jun 2020 15:55:12 -0400
IronPort-SDR: UgDqcUaBH6Z7j6RuDAbiTo7J5JXCtj8Tt3Flr6Zb1nQ0G/Qe43UBianefvjnxKMyye+ZugLHp3
 E55JWHqvCjxA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2020 12:55:11 -0700
IronPort-SDR: L9wi8U+03tTN6+vKwsCFCPmfXUX6scD66uycNs5QT+D0rVy04+ilW32NFUDhSPvD3YJ07a0Cbt
 Pu/Re4MQ226Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,519,1583222400"; 
   d="scan'208";a="261519323"
Received: from gosinald-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.36.106])
  by fmsmga007.fm.intel.com with ESMTP; 16 Jun 2020 12:55:02 -0700
Date:   Tue, 16 Jun 2020 22:55:01 +0300
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
Message-ID: <20200616195450.GA10412@linux.intel.com>
References: <20200601075218.65618-1-jarkko.sakkinen@linux.intel.com>
 <20200601075218.65618-13-jarkko.sakkinen@linux.intel.com>
 <m2img5tgtu.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2img5tgtu.fsf@oracle.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 05, 2020 at 09:09:49PM +0100, Darren Kenny wrote:
> TYPO: s/devilering/delivering/?

I decided to rewrite the whole thing:

  x86/sgx: Allow a limited use of ATTRIBUTE.PROVISIONKEY for attestation

  Provisioning Certification Enclave (PCE), the root of trust for other
  enclaves, generates a signing key from a fused key called Provisioning
  Certification Key. PCE can then use this key to certify an attestation key
  of a QE, e.g. we get the chain of trust down to the hardware if the Intel
  signed PCE is used.

  To use the needed keys, ATTRIBUTE.PROVISIONKEY is required but should be
  only allowed for those who actually need it so that only the trusted
  parties can certify QE's.

  Obviously the attestation service should know the public key of the used
  PCE and that way detect illegit attestation, but whitelisting the legit
  users still adds an additional layer of defence.

  Add new device file called /dev/sgx/provision. The sole purpose of this
  file is to provide file descriptors that act as privilege tokens to allow
  to build enclaves with ATTRIBUTE.PROVISIONKEY set. A new ioctl called
  SGX_IOC_ENCLAVE_SET_ATTRIBUTE is used to assign this token to an enclave.

> > + * sgx_ioc_enclave_set_attribute - handler for %SGX_IOC_ENCLAVE_SET_ATTRIBUTE
> > + * @filep:	open file to /dev/sgx
> > + * @arg:	userspace pointer to a struct sgx_enclave_set_attribute instance
> > + *
> > + * Mark the enclave as being allowed to access a restricted attribute bit.
> > + * The requested attribute is specified via the attribute_fd field in the
> > + * provided struct sgx_enclave_set_attribute.  The attribute_fd must be a
> > + * handle to an SGX attribute file, e.g. ?/dev/sgx/provision".
> 
> Maybe this should be simply a double-quote rather than the Unicode left
> quote?

Not sure how that got there but it is a mistake.

> Thanks,
> 
> Darren.

Thanks for the remarks.

/Jarkko
