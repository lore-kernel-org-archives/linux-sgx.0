Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 156D9C48BCF
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Jun 2021 16:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED559613AC
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Jun 2021 16:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbhFIQRp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Jun 2021 12:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbhFIQRp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Jun 2021 12:17:45 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704C3C061574
        for <linux-sgx@vger.kernel.org>; Wed,  9 Jun 2021 09:15:34 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id k5so1639918pjj.1
        for <linux-sgx@vger.kernel.org>; Wed, 09 Jun 2021 09:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nTNjDTeKL0HhW8xVh2zjwFybmSQHs9W21Ffi1wyI04E=;
        b=THWKWPwr0FC+41YlBCd/MzxWfbNG/9lKg2aVrMDwOKRAIZOAmgMNx+EiSFY74W4B5P
         Mp9JvrkBhko2No4XlV0P+m3sbuvp7aE7cfr4p1dYp2nWyKqR1D0niJI5bJisN+R4LMrR
         6Dq7ujkgdgbhfDQS18MB7zhiyL3cbhxFWrKtBLxCRpfkp9vzgOiq6JJ9UbNqywGh9Fvw
         Qsl74383q4pkqEx/XmEoD0nPqt0UL86grUS/NKI7jVYnjcluyiDiZoxvRHKhKBJ1GpJG
         t8gm6fMFGlVoRbuL/PQ3H4LwCP+ij1p0Jlv3APCzoJk0fyjm1eLoa0BdOvl46+IDAUog
         exgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nTNjDTeKL0HhW8xVh2zjwFybmSQHs9W21Ffi1wyI04E=;
        b=NR46oWziPGKX2EmfDoeZ3KjmQYCYwJVBj0804NVUEAjdCwuuKvG+mkJ031Hsm6of+o
         TZklcA28j7SO/KvJ/68ofUEpZ4QFoAL9ZSjgd44XOzr2WE6sJ9dcPN7ZE1W8OY4YQl5O
         wrgbM84tZqQ2w4yzF0Mb2ZVO18qqzacawiSW7ZBsI1TCNMrjdskmz3h1oXpoJqcQCr2M
         XjMVsVe/obt6FDpGtNhaCx6B0QtRMfO8FBpFiZ9dcnFslyzjKbTTHLXH6nqf1fn6uCt7
         LlpXNaXae13j35sSYWiOgtrEpNiaUiy4JTH2BWtHbFEKuTcwvI+HsH54vMtmdzeVe4uK
         VefQ==
X-Gm-Message-State: AOAM531ZCbMH/2iKH9IS2mkIMHe2Q10v+4Kl7cmjqzJcB0nKX2xRmRJv
        EMbFHXf44XfBxCnlSENpuYkGoj20ZdTs7Q==
X-Google-Smtp-Source: ABdhPJxVBjofJLwZc9ySJiONwNS5gRqh6hiCKhrG1pRdg0frZEn/6taeNeue76nIqwiHd4TL8tMw2g==
X-Received: by 2002:a17:902:f704:b029:f4:228d:4dca with SMTP id h4-20020a170902f704b02900f4228d4dcamr377225plo.26.1623255333818;
        Wed, 09 Jun 2021 09:15:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d66sm100986pfa.32.2021.06.09.09.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 09:15:33 -0700 (PDT)
Date:   Wed, 9 Jun 2021 16:15:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Du Cheng <ducheng2@gmail.com>, linux-sgx@vger.kernel.org,
        kai.huang@intel.com, dave.hansen@intel.com
Subject: Re: [BUG] bug report on x86/sgx: ksgxd()
Message-ID: <YMDpIVoLFqAJTD/B@google.com>
References: <YLb8y5YMFAsRKJMg@nuc>
 <20210603065745.v3iupi3k3oxea424@kernel.org>
 <YLlLsJQAQ5uQk+hf@google.com>
 <20210609125745.risptjqckh4kh3d5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609125745.risptjqckh4kh3d5@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 09, 2021, Jarkko Sakkinen wrote:
> Can you send a proper patch? I can also mangle a patch, if you don't have
> the bandwidth.

Yep, can do.
