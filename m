Return-Path: <SRS0=QZjA=S2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A74C10F03
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Apr 2019 00:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 567462148D
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Apr 2019 00:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbfDXA0z (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 23 Apr 2019 20:26:55 -0400
Received: from mga12.intel.com ([192.55.52.136]:57120 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfDXA0z (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 23 Apr 2019 20:26:55 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Apr 2019 17:26:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,387,1549958400"; 
   d="scan'208";a="164464910"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga004.fm.intel.com with ESMTP; 23 Apr 2019 17:26:53 -0700
Date:   Tue, 23 Apr 2019 17:26:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
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
        "luto@kernel.org" <luto@kernel.org>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>
Subject: Re: [PATCH v20 15/28] x86/sgx: Add the Linux SGX Enclave Driver
Message-ID: <20190424002653.GB14422@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190417103938.7762-16-jarkko.sakkinen@linux.intel.com>
 <20190422215831.GL1236@linux.intel.com>
 <6dd981a7-0e38-1273-45c1-b2c0d8bf6fed@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dd981a7-0e38-1273-45c1-b2c0d8bf6fed@fortanix.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Apr 23, 2019 at 11:29:24PM +0000, Jethro Beekman wrote:
> On 2019-04-22 14:58, Sean Christopherson wrote:
> >+Cc Jethro
> >
> >On Wed, Apr 17, 2019 at 01:39:25PM +0300, Jarkko Sakkinen wrote:
> >>Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> >>can be used by applications to set aside private regions of code and
> >>data. The code outside the enclave is disallowed to access the memory
> >>inside the enclave by the CPU access control.
> >>
> >>This commit adds the Linux SGX Enclave Driver that provides an ioctl API
> >>to manage enclaves. The address range for an enclave, commonly referred
> >>as ELRANGE in the documentation (e.g. Intel SDM), is reserved with
> >>mmap() against /dev/sgx/enclave. After that a set ioctls is used to
> >>build the enclave to the ELRANGE.
> >>
> >>Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> >>Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >>Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
> >>Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
> >>Co-developed-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
> >>Signed-off-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
> >>Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> >>Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> >>---
> >
> >...
> >
> >>+#ifdef CONFIG_ACPI
> >>+static struct acpi_device_id sgx_device_ids[] = {
> >>+	{"INT0E0C", 0},
> >>+	{"", 0},
> >>+};
> >>+MODULE_DEVICE_TABLE(acpi, sgx_device_ids);
> >>+#endif
> >>+
> >>+static struct platform_driver sgx_drv = {
> >>+	.probe = sgx_drv_probe,
> >>+	.remove = sgx_drv_remove,
> >>+	.driver = {
> >>+		.name			= "sgx",
> >>+		.acpi_match_table	= ACPI_PTR(sgx_device_ids),
> >>+	},
> >>+};
> >
> >Where do we stand on removing the ACPI and platform_driver dependencies?
> >Can we get rid of them sooner rather than later?
> 
> You know my position on this...
> https://www.spinics.net/lists/linux-sgx/msg00624.html . I don't really have
> any new arguments.
> 
> Considering the amount of planned changes for the driver post-merge, I think
> it's crucial that the driver part can be swapped out with alternative
> implementations.

This gets far outside of my area of expertise as I think this is more of
a policy question as opposed to a technical question, e.g. do we export
function simply to allow out-of-tree alternatives.

> >Now that the core SGX code is approaching stability, I'd like to start
> >sending RFCs for the EPC virtualization and KVM bits to hash out that side
> >of things.  The ACPI crud is the last chunk of code that would require
> >non-trivial changes to the core SGX code for the proposed virtualization
> >implementation.  I'd strongly prefer to get it out of the way before
> >sending the KVM RFCs.
> 
> What kind of changes? Wouldn't KVM just be another consumer of the same API
> used by the driver?

Nope, userspace "only" needs to be able to mmap() arbitrary chunks of EPC.
Except for EPC management, which is already in built into the kernel, the
EPC virtualization code has effectively zero overlap with the driver.  Of
course this is all technically speculative since none of this is upstream...
