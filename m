Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90861C27C47
	for <linux-sgx@archiver.kernel.org>; Sat, 28 Oct 2023 08:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjJ1IYK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 28 Oct 2023 04:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjJ1IYJ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 28 Oct 2023 04:24:09 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC059F4;
        Sat, 28 Oct 2023 01:24:07 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-99c3c8adb27so417937066b.1;
        Sat, 28 Oct 2023 01:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698481446; x=1699086246; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NvHLJkc4vz+ewbng+qiWVXp1pmuOUJA9AviIjHtZepY=;
        b=SC/JD3zQOVc8NjgLsE7mTszIDcyvRQ0rcQPNMD/3pZ5ePdeVAi/+MVa6GI3kJUj8cF
         pXybp7Lpp3kVdjvD+gFU8MZre0xVxzLkWmeNl3LfQq+HXIKhE2AuYrulk51c+NImsZ4T
         XDJNyrek2C5K+Fg1LgkRdHjCC36fIfwTV7Q3ZZURQE7COotFEOPznXwMN+2K+EbMxlVI
         LXJztGBZYQ5rtR/7QirPuATbRLbTA3X13+N4zsLaNylPc94EDWU/VnofqudyLADnGavU
         Q4K8q4i/Dpdu2wmfNbWHxSkSBIYd68bRWCzm/BpESYzbVXEerDQQ/zWM6F1hPniGj6u6
         FsWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698481446; x=1699086246;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NvHLJkc4vz+ewbng+qiWVXp1pmuOUJA9AviIjHtZepY=;
        b=iAlB9ukYdr8EO3jiX/x8qpjyoTYgWrw99t/nSZVrJ4NF/wROCqTr1ubbOWeAO1sO4V
         xKXQXZKvMEWFUM5z+jCwfINxdEds1xMLM35Z0zdyxbkwPZ3oKSkL0OJgCs0M+0k4cuXn
         VI8AxFbKTJucRLhmmSp8/tIHds31LKiRUz/4kfbbioT0XjZs8q3ecRqilFqlgqbB6X1/
         TKvtM/L4IjpFMbR2tLowGPawIqlF/N4917UyPuDaVIrgeHNUJBXFsVw5Jh0YG1RhmMpK
         xT/Qc74cgGrOIlv9I0C+dI0q4z1oVIIDyw+QauIKhR/r9wSXGSP/Fghrj1yZYZLH8S4B
         4I+A==
X-Gm-Message-State: AOJu0YweSxEIG7JaWOSP5P2c8ZJc8S5hdw8c1qYi7M0mRe4zaKNjEp+m
        q5cLMQiiO3D9i1pALpzqZz7Lrwt5cYk=
X-Google-Smtp-Source: AGHT+IFte2+bKZoisXNo7/RhMBMe7DleFnHsbzlCaopU7VmSYhuHgyVHQhwflI3HiiZr04n7OHlJvQ==
X-Received: by 2002:a17:907:3f05:b0:9c2:2d0a:3211 with SMTP id hq5-20020a1709073f0500b009c22d0a3211mr3760303ejc.38.1698481445969;
        Sat, 28 Oct 2023 01:24:05 -0700 (PDT)
Received: from gmail.com (1F2EF1E7.nat.pool.telekom.hu. [31.46.241.231])
        by smtp.gmail.com with ESMTPSA id 26-20020a508e1a000000b0053df23511b0sm2509055edw.29.2023.10.28.01.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Oct 2023 01:24:05 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Sat, 28 Oct 2023 10:24:03 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/sgx: Return VM_FAULT_SIGBUS for EPC exhaustion
Message-ID: <ZTzFI5+hniEQhU2+@gmail.com>
References: <20231020025353.29691-1-haitao.huang@linux.intel.com>
 <b8ec3061-436f-41d3-8bff-635a90774dfb@intel.com>
 <b389986bac0e65ce128c9553603436efdda24a58.camel@intel.com>
 <b709d680-5754-45ab-ae73-c812420f10e5@intel.com>
 <op.2dfkbh2iwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <504d71debc56c89860942283ae638e5950deb79c.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504d71debc56c89860942283ae638e5950deb79c.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


* Huang, Kai <kai.huang@intel.com> wrote:

> On Thu, 2023-10-26 at 11:34 -0500, Haitao Huang wrote:
> > On Thu, 26 Oct 2023 11:01:57 -0500, Reinette Chatre  
> > <reinette.chatre@intel.com> wrote:
> > 
> > > 
> > > 
> > > On 10/25/2023 4:58 PM, Huang, Kai wrote:
> > > > On Wed, 2023-10-25 at 07:31 -0700, Hansen, Dave wrote:
> > > > > On 10/19/23 19:53, Haitao Huang wrote:
> > > > > > In the EAUG on page fault path, VM_FAULT_OOM is returned when the
> > > > > > Enclave Page Cache (EPC) runs out. This may trigger unneeded OOM kill
> > > > > > that will not free any EPCs. Return VM_FAULT_SIGBUS instead.
> > > 
> > > This commit message does not seem accurate to me. From what I can tell
> > > VM_FAULT_SIGBUS is indeed returned when EPC runs out. What is addressed
> > > with this patch is the error returned when kernel (not EPC) memory runs
> > > out.
> > > 
> > 
> > 
> > Sorry I got it mixed up between sgx_alloc_epc_page and sgx_encl_page_alloc  
> > returns.
> > You are right. Please drop this patch.
> > 
> 
> It's already in tip/x86/urgent.  Please send a patch to revert?

No, let's just zap it.

Thanks,

	Ingo
