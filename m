Return-Path: <SRS0=n9z9=PB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71724C43387
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Dec 2018 11:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C2F721738
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Dec 2018 11:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbeLXLxW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 24 Dec 2018 06:53:22 -0500
Received: from mga04.intel.com ([192.55.52.120]:26933 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbeLXLxV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 24 Dec 2018 06:53:21 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Dec 2018 03:53:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,392,1539673200"; 
   d="scan'208";a="121343527"
Received: from dlu2-mobl4.ccr.corp.intel.com (HELO localhost) ([10.249.254.240])
  by orsmga001.jf.intel.com with ESMTP; 24 Dec 2018 03:53:16 -0800
Date:   Mon, 24 Dec 2018 13:53:15 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@intel.com" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kai.svahn@intel.com" <kai.svahn@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>
Subject: Re: [PATCH v18 10/25] x86/sgx: Add ENCLS architectural error codes
Message-ID: <20181224115315.GB10971@linux.intel.com>
References: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
 <20181221231154.6120-11-jarkko.sakkinen@linux.intel.com>
 <4966112d-36b3-37e7-4344-2a0401a1f73d@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4966112d-36b3-37e7-4344-2a0401a1f73d@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 24, 2018 at 05:17:16AM +0000, Jethro Beekman wrote:
> On 2018-12-22 04:41, Jarkko Sakkinen wrote> +#ifndef
> _UAPI_ASM_X86_SGX_ERRNO_H
> > +#define _UAPI_ASM_X86_SGX_ERRNO_H
> > +
> > +/**
> > + * enum sgx_encls_leaves - return codes for ENCLS, ENCLU and ENCLV
> > + * %SGX_SUCCESS:		No error.
> > + * %SGX_INVALID_SIG_STRUCT:	SIGSTRUCT contains an invalid value.
> > + * %SGX_INVALID_ATTRIBUTE:	Enclave is not attempting to access a resource
> > + *				for which it is not authorized.
> > + * %SGX_BLKSTATE:		EPC page is already blocked.
> 
> Is it BLSTATE (SDM §40.1.4) or BLKSTATE (SDM §40.3)?

Ugh, have to say that zero idea.

/Jarkko
