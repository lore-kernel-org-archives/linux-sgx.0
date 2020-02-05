Return-Path: <SRS0=YPok=3Z=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C4DC35247
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Feb 2020 15:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54C9D20702
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Feb 2020 15:58:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgBEP6T (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Feb 2020 10:58:19 -0500
Received: from mga18.intel.com ([134.134.136.126]:21512 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726933AbgBEP6T (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Feb 2020 10:58:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 07:58:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,406,1574150400"; 
   d="scan'208";a="249747889"
Received: from hhuan26-mobl1.amr.corp.intel.com ([10.254.98.107])
  by orsmga002.jf.intel.com with ESMTP; 05 Feb 2020 07:58:16 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        "Jarkko Sakkinen" <jarkko.sakkinen@intel.com>,
        linux-security-module@vger.kernel.org,
        "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v25 10/21] x86/sgx: Linux Enclave Driver
References: <20200204060545.31729-1-jarkko.sakkinen@linux.intel.com>
 <20200204060545.31729-11-jarkko.sakkinen@linux.intel.com>
Date:   Wed, 05 Feb 2020 09:58:15 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.0fiundhawjvjmi@hhuan26-mobl1.amr.corp.intel.com>
In-Reply-To: <20200204060545.31729-11-jarkko.sakkinen@linux.intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 04 Feb 2020 00:05:34 -0600, Jarkko Sakkinen  
<jarkko.sakkinen@linux.intel.com> wrote:
...
> +const struct file_operations sgx_provision_fops = {
> +	.owner			= THIS_MODULE,
> +};
> +
> +static struct miscdevice sgx_dev_enclave = {
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = "enclave",
> +	.nodename = "sgx/enclave",
> +	.fops = &sgx_encl_fops,
> +};
> +

How does kernel manage name conflict if multiple misc device requesting  
"enclave" ?

And the attributes for a udev rule to match this device according to  
udevadm output are:
SUBSYSTEM=="misc",KERNEL=="enclave"

Is that specific enough to uniquely match this device?

Similar questions for the "provision" device introduced later in this  
series.

Thanks
Haitao
