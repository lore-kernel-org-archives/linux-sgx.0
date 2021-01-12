Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB34C43142
	for <linux-sgx@archiver.kernel.org>; Tue, 12 Jan 2021 21:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE88423123
	for <linux-sgx@archiver.kernel.org>; Tue, 12 Jan 2021 21:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbhALVqa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 12 Jan 2021 16:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388398AbhALVqM (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 12 Jan 2021 16:46:12 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9FDC061575
        for <linux-sgx@vger.kernel.org>; Tue, 12 Jan 2021 13:45:32 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 11so2220061pfu.4
        for <linux-sgx@vger.kernel.org>; Tue, 12 Jan 2021 13:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=vFJ/rFa4+Sg1hSl8x3O3B/ZIA0gEVYoqC8NmFooiOm0=;
        b=wCA645tOz/mMX8wP55qrAguMJS197Qs3wIkh0y4st7n/0CHiK/UwPZwyCO+n4vY8s5
         ZrTjQw4LZbhAN6v5s9I8MGW4bdXeceGByJNmlzbYr8pIV0DzKGAidchlmrg3hP/AvTj2
         WcUcvrxiLt0C32T/oG2C7RGVw9VMEP7/agFvlioqjyNWZc6SXScABdHRvib1HrZhZbwq
         apHaqKGIkz+N9oD1C7pwvss4yzcpQikEEfTSxKeqz7sbw3OSm85JN4yfBi18BPuHiuI5
         ygMJg5XjcGYUSYg1Vwn5nuVxOsp8AF1WiEQtloclykGZrQDt7ryFwfP81LzyZaKl3VrE
         Mldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=vFJ/rFa4+Sg1hSl8x3O3B/ZIA0gEVYoqC8NmFooiOm0=;
        b=G85MQinxp53IWow7EVcWlOJ7gSr7kb+QJCbQ1BHnynGix7UvQ9S+/tbINtWV9EJzeA
         X9iyo2QWjQiW9+aMvJJpT/z5uob5HbXiDIosUQWc76pJKD4ypTvKwxGZw5Bi2FZ5Y1ck
         kyN72BX+ReFNx6XZ97wMtim1/acRkmW5o018fBC42NHnm7O6CvsO77m2d52Ca8BrxGiv
         NJCz+OoEFxghJw05qm8Oef/GXadCMmMtwGwZYDojEDdVsFrY1gg4GU5imjtUV+p3IVMK
         vkDSbdbkz2RQmfsU9SzQIj6oFkI4nr8PaHbQoZZWNLemhX4tifCOKQ0GrLmDr55dl9We
         KMfw==
X-Gm-Message-State: AOAM5331aa4PIXHvlL8ldHKnKUbQBT5lrx1dWCGxGsgch/w4ZAPKNVng
        QdsGQLACEEq2jcBKrcq9BusCbg==
X-Google-Smtp-Source: ABdhPJzUiHLIf6SN0zRWzersJQF2wrvUwAL6nSwXwPhNQPaix2oiqFI7jyJ+ueOK+QoT0VqFHLQ3Qw==
X-Received: by 2002:a63:cf06:: with SMTP id j6mr1049819pgg.195.1610487931868;
        Tue, 12 Jan 2021 13:45:31 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id k3sm4272752pgm.94.2021.01.12.13.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 13:45:31 -0800 (PST)
Date:   Tue, 12 Jan 2021 13:45:24 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 01/23] x86/sgx: Split out adding EPC page to free
 list to separate helper
Message-ID: <X/4YdCN9LwZGompH@google.com>
References: <cover.1609890536.git.kai.huang@intel.com>
 <3d50c2614ff8a46b44062a398fd8644bcda92132.1609890536.git.kai.huang@intel.com>
 <31681b840aac59a8d8dcb05f2356d25cf09e1f11.camel@kernel.org>
 <20210112131944.9d69bb30cf4b94b6f6f25e7b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210112131944.9d69bb30cf4b94b6f6f25e7b@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jan 12, 2021, Kai Huang wrote:
> On Tue, 12 Jan 2021 00:38:40 +0200 Jarkko Sakkinen wrote:
> > On Wed, 2021-01-06 at 14:55 +1300, Kai Huang wrote:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > 
> > > SGX virtualization requires to allocate "raw" EPC and use it as virtual
> > > EPC for SGX guest.  Unlike EPC used by SGX driver, virtual EPC doesn't
> > > track how EPC pages are used in VM, e.g. (de)construction of enclaves,
> > > so it cannot guarantee EREMOVE success, e.g. it doesn't have a priori
> > > knowledge of which pages are SECS with non-zero child counts.
> > > 
> > > Split sgx_free_page() into two parts so that the "add to free list"
> > > part can be used by virtual EPC without having to modify the EREMOVE
> > > logic in sgx_free_page().
> > > 
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > 
> > I have a better idea with the same outcome for KVM.
> > 
> > https://lore.kernel.org/linux-sgx/20210111223610.62261-1-jarkko@kernel.org/T/#t
> 
> I agree with your patch this one can be replaced. I'll include your patch in
> next version, and once it is upstreamed, it can be removed in my series.
> 
> Sean, please let me know if you have objection.

6 of one, half dozen of the other.  I liked not having to modify the existing
call sites, but it's your code.

Though on that topic, this snippet is wrong:

@@ -431,7 +443,8 @@ void sgx_encl_release(struct kref *ref)
 		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 					   list);
 		list_del(&va_page->list);
-		sgx_free_epc_page(va_page->epc_page);
+		sgx_reset_epc_page(entry->epc_page);
+		sgx_free_epc_page(entry->epc_page);

s/entry/va_page in the new code.

P.S. I apparently hadn't been subscribed linux-sgx and so didn't see those
     patches.  I'm now subscribed and can chime-in as needed.
