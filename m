Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 954B2C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Jan 2021 00:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 614AC23718
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Jan 2021 00:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390272AbhAUAMz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Jan 2021 19:12:55 -0500
Received: from mga03.intel.com ([134.134.136.65]:43800 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404119AbhATXZn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Jan 2021 18:25:43 -0500
IronPort-SDR: gFY2GkVHnxs/ZRnbH1dKyEAUX4V2AtZEsYbzf3Zy03g92/OIV3EOWLD6fmknXsgB8wkpevlDsf
 OumnKIxa+eYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="179275217"
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="179275217"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 15:24:58 -0800
IronPort-SDR: j4uQzzNZ7oqsq4Q5dSwpCAACXOolxIMD8bMx+jH+pjD7zxRJytLD2ELicS7P+tWambE9Nls6tu
 +gBgRlshCU7Q==
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="354476752"
Received: from gapoveda-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.79.186])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 15:24:54 -0800
Date:   Thu, 21 Jan 2021 12:24:53 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 14/26] x86/sgx: Move provisioning device creation
 out of SGX driver
Message-Id: <20210121122453.4481ba33c9af309362d7ba79@intel.com>
In-Reply-To: <YAg5qU5KMGLuPdjy@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
        <4aeb65be69701a4a6e7d479ad3563bf7a9f052d5.1610935432.git.kai.huang@intel.com>
        <YAg5qU5KMGLuPdjy@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> >  
> > +const struct file_operations sgx_provision_fops = {
> > +	.owner			= THIS_MODULE,
> > +};
> > +
> > +static struct miscdevice sgx_dev_provision = {
> > +	.minor = MISC_DYNAMIC_MINOR,
> > +	.name = "sgx_provision",
> > +	.nodename = "sgx_provision",
> > +	.fops = &sgx_provision_fops,
> > +};
> > +
> > +int sgx_set_attribute(unsigned long *allowed_attributes,
> > +		      unsigned int attribute_fd)
> 
> kdoc

Will do.

> 
> > +{
> > +	struct file *file;
> > +
> > +	file = fget(attribute_fd);
> > +	if (!file)
> > +		return -EINVAL;
> > +
> > +	if (file->f_op != &sgx_provision_fops) {
> > +		fput(file);
> > +		return -EINVAL;
> > +	}
> > +
> > +	*allowed_attributes |= SGX_ATTR_PROVISIONKEY;
> > +
> > +	fput(file);
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(sgx_set_attribute);
> > +
