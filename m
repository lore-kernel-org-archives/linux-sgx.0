Return-Path: <SRS0=TyRD=Z5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82EC6C43603
	for <linux-sgx@archiver.kernel.org>; Sat,  7 Dec 2019 08:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58EDC24677
	for <linux-sgx@archiver.kernel.org>; Sat,  7 Dec 2019 08:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575706185;
	bh=ka9twd3f9Ty1CXid7X6crb8J+0HJg7UfRGdoa9Nv64s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=myidFY7VmCDe4f/xh7n7oZr/7MFW01vks/+oJ9/kMxGzZkBb9BWJxH7ZQzpRBnvtE
	 bC2x+7fNUflKL914DI2cyzmARKxcuwCeMNQIChccPYmkV8448eOgV3rMs9taDItk9/
	 cSkjQK5pLbx+ST1vTE1uf3RPPFFNcSf0DtaYBns0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfLGIJm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 7 Dec 2019 03:09:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:54682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbfLGIJm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 7 Dec 2019 03:09:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 726B12173E;
        Sat,  7 Dec 2019 08:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575706182;
        bh=ka9twd3f9Ty1CXid7X6crb8J+0HJg7UfRGdoa9Nv64s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E+SPt6vh/IIeHtU3r2uxwF0NrKJOZj9vsujceIkuISVHmj4XgMIUjyCmuSmz1DXn/
         UEt58uxJswsrA3NBZCWVGx8+kAkUUeXzLMV5oPKwpyCncTU+yULGcal4wYH7BYz0La
         gqSNfXSpZWCihftEKGUXVk8d8XTNOcGFf2k4e4kM=
Date:   Sat, 7 Dec 2019 09:09:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v23 12/24] x86/sgx: Linux Enclave Driver
Message-ID: <20191207080939.GA193518@kroah.com>
References: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
 <20191028210324.12475-13-jarkko.sakkinen@linux.intel.com>
 <20191128182450.GA3493127@kroah.com>
 <20191206203807.GA9971@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206203807.GA9971@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 06, 2019 at 10:38:07PM +0200, Jarkko Sakkinen wrote:
> > Why a whole cdev?
> > 
> > Why not use a misc device?  YOu only have 2 devices right?  Why not 2
> > misc devices then?  That saves the use of a whole major number and makes
> > your code a _LOT_ simpler.
> 
> The downside would be that if we ever want to add sysfs attributes, that
> could not be done synchronously with the device creation.

That is what the groups member of struct misc_device is for.

greg k-h

