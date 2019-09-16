Return-Path: <SRS0=4JBP=XL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11028C49ED7
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 05:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D571720890
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 05:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfIPFYE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Sep 2019 01:24:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:10041 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbfIPFYE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Sep 2019 01:24:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Sep 2019 22:24:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,510,1559545200"; 
   d="scan'208";a="216087558"
Received: from abonnier-mobl5.ger.corp.intel.com (HELO localhost) ([10.252.54.54])
  by fmsmga002.fm.intel.com with ESMTP; 15 Sep 2019 22:23:54 -0700
Date:   Mon, 16 Sep 2019 08:23:49 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com
Subject: Re: [PATCH v22 00/24] Intel SGX foundations
Message-ID: <20190916052349.GA4556@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <eed916f3-73e1-2695-4cd1-0b252ac9b553@intel.com>
 <20190914134136.GG9560@linux.intel.com>
 <8339d3c0-8e80-9cd5-948e-47733f7c29b7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8339d3c0-8e80-9cd5-948e-47733f7c29b7@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Sep 14, 2019 at 08:32:38AM -0700, Dave Hansen wrote:
> On 9/14/19 6:41 AM, Jarkko Sakkinen wrote:
> > 
> > The proposed LSM hooks give the granularity to make yes/no decision
> > based on the
> > 
> > * The origin of the source of the source for the enclave.
> > * The requested permissions for the added or mapped peage.
> > 
> > The hooks to do these checks are provided for mmap() and EADD
> > operations.
> > 
> > With just file permissions you can still limit mmap() by having a
> > privileged process to build the enclaves and pass the file descriptor
> > to the enclave user who can mmap() the enclave within the constraints
> > set by the enclave pages (their permissions refine the roof that you
> > can mmap() any memory range within an enclave).
> 
> The LSM hooks are presumably fixing a problem that these patches
> introduce.  What's that problem?

I've seen the claims that one would have to degrade one's LSM policy but
I don't think that is true.

With just UNIX permissions you have probably have to restrict the access
to /dev/sgx/enclave to control who can build enclaves. The processes who
do not have this privilege can mmap() the enclave once they get the file
descriptor through forking or SCM_RIGHTS.

After SGX_IOC_ENCLAVE_INIT, the memory layout is sealed and the client
process can only use the enclave.

Further, we have /dev/sgx/provision to restrict, which enclaves can
attest themselves to a remote party.

*If anything*, I would rather investigate possibility to use keyring for
enclave signer's public keys or perhaps having extended attribute for
the signer (SHA256) in the enclave file that could be compared during
the EINIT.

I think either can be considered post-upstreaming.

/Jarkko
