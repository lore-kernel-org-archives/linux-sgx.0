Return-Path: <SRS0=ViI6=XJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D240EC4CEC7
	for <linux-sgx@archiver.kernel.org>; Sat, 14 Sep 2019 13:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BD0F20692
	for <linux-sgx@archiver.kernel.org>; Sat, 14 Sep 2019 13:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730629AbfINNlr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 14 Sep 2019 09:41:47 -0400
Received: from mga07.intel.com ([134.134.136.100]:45613 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728741AbfINNlr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 14 Sep 2019 09:41:47 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Sep 2019 06:41:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,505,1559545200"; 
   d="scan'208";a="201241955"
Received: from krusocki-mobl.ger.corp.intel.com (HELO localhost) ([10.252.40.34])
  by fmsmga001.fm.intel.com with ESMTP; 14 Sep 2019 06:41:38 -0700
Date:   Sat, 14 Sep 2019 14:41:36 +0100
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
Message-ID: <20190914134136.GG9560@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <eed916f3-73e1-2695-4cd1-0b252ac9b553@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eed916f3-73e1-2695-4cd1-0b252ac9b553@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 13, 2019 at 01:38:18PM -0700, Dave Hansen wrote:
> On 9/3/19 7:26 AM, Jarkko Sakkinen wrote:
> > Not having LSM hooks does not cause any risk to other parts of the
> > kernel as the device can still be controlled by using DAC permissions.
> > The hooks just provide more granularity than DAC in access decisions.
> 
> Could we translate the security-speak to english, please? :)
> 
> Is this it:
> 
> 	LSMs can (try to) enforce things like "all executable code must
> 	be verified".  The implementation in these patches has the
> 	potential to subvert policies like that since it has its own
> 	unique mechanisms for loading and mapping executable code.  This
> 	will be fixed by future LSM enhancements on top of this set.
> 	For now, permissions on the SGX device file should be used to
> 	prevent untrusted users from using SGX to subvert LSM policies.

I'm not sure what "security-speak" is but lets try plain English and
see where we get from there.

The proposed LSM hooks give the granularity to make yes/no decision
based on the

* The origin of the source of the source for the enclave.
* The requested permissions for the added or mapped peage.

The hooks to do these checks are provided for mmap() and EADD
operations.

With just file permissions you can still limit mmap() by having a
privileged process to build the enclaves and pass the file descriptor
to the enclave user who can mmap() the enclave within the constraints
set by the enclave pages (their permissions refine the roof that you
can mmap() any memory range within an enclave).

/Jarkko
