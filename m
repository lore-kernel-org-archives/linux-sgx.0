Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C74C8C43381
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Jan 2021 01:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 796F8238E2
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Jan 2021 01:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390855AbhAUBL5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Jan 2021 20:11:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390773AbhAUBLs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Jan 2021 20:11:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A81D2388A;
        Thu, 21 Jan 2021 01:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611191467;
        bh=gTNb7TfO+W02yaMYrGDKsEfsInP+n74v+GCaJVdRLMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LI5cPfd6rzH47946G3BLn+B6Qy7fvvCpt0nHK1Z7KgDXsDwaN2rkGQzblDoaZetvr
         dpzyYODjGIVJKoIChRuUXGFt1bV0yU2KrSBtAwJiG7FzcBYQ+dfQ1I5Nf/4sQiR3fs
         v4E0TA4AWRw7r5JeFUUsoWIbtTxK0jokFttltt5VY8dnjFKSvppjRA6fY+ZdCcYP+K
         /zmJAFoKkLyUXIAGGiDEYfJ4YZHg4xzjC0tGtFshYrzWNR8I2o+vOcFeVM+5LYgC1o
         S7xEnlP3TfP1azqDtzUzDLzC+16ep7HJgRlfETWhnkutfnsbSTM2TMEf8wpYl+Bpqk
         5MAfji9vwvLgg==
Date:   Thu, 21 Jan 2021 03:11:01 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de
Subject: Re: [RFC PATCH v2 06/26] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Message-ID: <YAjUpdrmGDuCLAwg@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <a6c0b0d2632a6c603e68d9bdc81f564290ff04ad.1610935432.git.kai.huang@intel.com>
 <bc73adaf-fae6-2088-c8d4-6f53057a4eac@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc73adaf-fae6-2088-c8d4-6f53057a4eac@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jan 20, 2021 at 01:02:15PM -0800, Dave Hansen wrote:
> On 1/17/21 7:27 PM, Kai Huang wrote:
> > -	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
> > -		     cpu_has(c, X86_FEATURE_SGX_LC) &&
> > -		     IS_ENABLED(CONFIG_X86_SGX);
> > +	enable_sgx_driver = cpu_has(c, X86_FEATURE_SGX) &&
> > +			    cpu_has(c, X86_FEATURE_SGX1) &&
> > +			    IS_ENABLED(CONFIG_X86_SGX) &&
> > +			    cpu_has(c, X86_FEATURE_SGX_LC);
> > +	enable_sgx_virt = cpu_has(c, X86_FEATURE_SGX) &&
> > +			  cpu_has(c, X86_FEATURE_SGX1) &&
> > +			  IS_ENABLED(CONFIG_X86_SGX) &&
> > +			  IS_ENABLED(CONFIG_X86_SGX_VIRTUALIZATION) &&
> > +			  enable_vmx;
> 
> Would it be too much to ask that the SGX/SGX1 checks not be duplicated?
>  Perhaps:
> 
> 	enable_sgx_any = cpu_feature_enabled(CONFIG_X86_SGX) &&
> 			 cpu_feature_enabled(CONFIG_X86_SGX1);
> 
> 	enable_sgx_driver = enable_sgx_any &&
> 			    cpu_has(c, X86_FEATURE_SGX_LC);
> 
> 	enable_sgx_virt = enable_sgx_any &&
> 			  enable_vmx &&
> 		     IS_ENABLED(CONFIG_X86_SGX_VIRTUALIZATION)
> 
> BTW, CONFIG_X86_SGX_VIRTUALIZATION is a pretty porky name.  Maybe just
> CONFIG_X86_SGX_VIRT?

If my /dev/sgx_vepc naming gets acceptance, then IMHO the best name
ought to be CONFIG_X86_VEPC.

/Jarkko
