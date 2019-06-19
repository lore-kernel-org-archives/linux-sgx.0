Return-Path: <SRS0=/aec=US=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDAEC31E49
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 14:56:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFCF12183F
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 14:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbfFSO4Y (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Jun 2019 10:56:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:4516 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbfFSO4Y (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Jun 2019 10:56:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 07:56:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,392,1557212400"; 
   d="scan'208";a="162066889"
Received: from stephanf-mobl2.ger.corp.intel.com ([10.252.34.117])
  by fmsmga007.fm.intel.com with ESMTP; 19 Jun 2019 07:56:18 -0700
Message-ID: <0c4f75a0ae2fdeee6db07f3a224918f321163d56.camel@linux.intel.com>
Subject: Re: [RFC PATCH v3 09/12] LSM: x86/sgx: Introduce ->enclave_load()
 hook for Intel SGX
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        jmorris@namei.org
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>, casey.schaufler@intel.com,
        william.c.roberts@intel.com
Date:   Wed, 19 Jun 2019 17:56:06 +0300
In-Reply-To: <20190617222438.2080-10-sean.j.christopherson@intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
         <20190617222438.2080-10-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2019-06-17 at 15:24 -0700, Sean Christopherson wrote:
> enclave_load() is roughly analogous to the existing file_mprotect().
> 
> Due to the nature of SGX and its Enclave Page Cache (EPC), all enclave
> VMAs are backed by a single file, i.e. /dev/sgx/enclave, that must be
> MAP_SHARED.  Furthermore, all enclaves need read, write and execute
> VMAs.  As a result, the existing/standard call to file_mprotect() does
> not provide any meaningful security for enclaves since an LSM can only
> deny/grant access to the EPC as a whole.
> 
> security_enclave_load() is called when SGX is first loading an enclave
> page, i.e. copying a page from normal memory into the EPC.  Although
> the prototype for enclave_load() is similar to file_mprotect(), e.g.
> SGX could theoretically use file_mprotect() and set reqprot=prot, a
> separate hook is desirable as the semantics of an enclave's protection
> bits are different than those of vmas, e.g. an enclave page tracks the
> maximal set of protections, whereas file_mprotect() operates on the
> actual protections being provided.  Enclaves also have unique security
> properties, e.g. measured code, that LSMs may want to consider.  In
> other words, LSMs will likely want to implement different policies for
> enclave page protections.
> 
> Note, extensive discussion yielded no sane alternative to some form of
> SGX specific LSM hook[1].
> 
> [1] 
> 
https://lkml.kernel.org/r/CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Can LSM callbacks ever non-generic when it comes to hardware? This is
the very first time I ever see such callbacks being introduced.

I suspect that from maintainers perspective, accepting such changes for
Intel hardware, could open a pandoras box.

/Jarkko

