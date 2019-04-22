Return-Path: <SRS0=gKhM=SY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DC6C10F11
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 21:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B259A2064A
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 21:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbfDVV6c (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Apr 2019 17:58:32 -0400
Received: from mga18.intel.com ([134.134.136.126]:2223 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728619AbfDVV6c (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 22 Apr 2019 17:58:32 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Apr 2019 14:58:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,383,1549958400"; 
   d="scan'208";a="225739933"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga001.jf.intel.com with ESMTP; 22 Apr 2019 14:58:31 -0700
Date:   Mon, 22 Apr 2019 14:58:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v20 15/28] x86/sgx: Add the Linux SGX Enclave Driver
Message-ID: <20190422215831.GL1236@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190417103938.7762-16-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417103938.7762-16-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

+Cc Jethro

On Wed, Apr 17, 2019 at 01:39:25PM +0300, Jarkko Sakkinen wrote:
> Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> can be used by applications to set aside private regions of code and
> data. The code outside the enclave is disallowed to access the memory
> inside the enclave by the CPU access control.
> 
> This commit adds the Linux SGX Enclave Driver that provides an ioctl API
> to manage enclaves. The address range for an enclave, commonly referred
> as ELRANGE in the documentation (e.g. Intel SDM), is reserved with
> mmap() against /dev/sgx/enclave. After that a set ioctls is used to
> build the enclave to the ELRANGE.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
> Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
> Co-developed-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
> Signed-off-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
> Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---

...

> +#ifdef CONFIG_ACPI
> +static struct acpi_device_id sgx_device_ids[] = {
> +	{"INT0E0C", 0},
> +	{"", 0},
> +};
> +MODULE_DEVICE_TABLE(acpi, sgx_device_ids);
> +#endif
> +
> +static struct platform_driver sgx_drv = {
> +	.probe = sgx_drv_probe,
> +	.remove = sgx_drv_remove,
> +	.driver = {
> +		.name			= "sgx",
> +		.acpi_match_table	= ACPI_PTR(sgx_device_ids),
> +	},
> +};

Where do we stand on removing the ACPI and platform_driver dependencies?
Can we get rid of them sooner rather than later?

Now that the core SGX code is approaching stability, I'd like to start
sending RFCs for the EPC virtualization and KVM bits to hash out that side
of things.  The ACPI crud is the last chunk of code that would require
non-trivial changes to the core SGX code for the proposed virtualization
implementation.  I'd strongly prefer to get it out of the way before
sending the KVM RFCs.

> +static int __init sgx_drv_subsys_init(void)
> +{
> +	int ret;
> +
> +	ret = bus_register(&sgx_bus_type);
> +	if (ret)
> +		return ret;
> +
> +	ret = alloc_chrdev_region(&sgx_devt, 0, SGX_DRV_NR_DEVICES, "sgx");
> +	if (ret < 0) {
> +		bus_unregister(&sgx_bus_type);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void sgx_drv_subsys_exit(void)
> +{
> +	bus_unregister(&sgx_bus_type);
> +	unregister_chrdev_region(sgx_devt, SGX_DRV_NR_DEVICES);
> +}
> +
> +static int __init sgx_drv_init(void)
> +{
> +	int ret;
> +
> +	ret = sgx_drv_subsys_init();
> +	if (ret)
> +		return ret;
> +
> +	ret = platform_driver_register(&sgx_drv);
> +	if (ret)
> +		sgx_drv_subsys_exit();
> +
> +	return ret;
> +}
> +module_init(sgx_drv_init);
> +
> +static void __exit sgx_drv_exit(void)
> +{
> +	platform_driver_unregister(&sgx_drv);
> +	sgx_drv_subsys_exit();
> +}
> +module_exit(sgx_drv_exit);
