Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EBF204097
	for <linux-sgx@vger.kernel.org>; Tue,  4 Mar 2025 13:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741093553; cv=none; b=McvPBfHsk6Quq8IQBsq5Yy1JRygyV3mDzGTnD8ZWz5nkMAEU4/QuKh4TTEdifAiBM8Z2+uj9vaGVflF5+FQ6KADtAKv95UvYgREzFlHzDA5kwEVOgANcOKE5VaP0nFgVulUMA0CTBBjBiLIeaiqMePIblSDFX3UDa+8sV88D2CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741093553; c=relaxed/simple;
	bh=i7b9HE14uEQMAv93kZIo0cZlCekD4srHfsuLDWfkJeg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=vGTi+FmMtibNnEMOLRxttAVYPrRyPQJDmzmzjqWVgYkWidZc3TtHAewVEzc7GRkA6uJM1mpu2JkVAiBsXvZn2qrhyMYZwTmHl6dkQbZX3JK9F4/mFDNXC6I71kbwdx2GRrYeZnc9GM/oM4jMvl9rQAoHl6aZPsp0Ke/+oxKnaCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=J7GQch4y; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J7GQch4y"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-390f5f48eafso1771965f8f.0
        for <linux-sgx@vger.kernel.org>; Tue, 04 Mar 2025 05:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741093550; x=1741698350; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8N2txbd/9bq4xEXbck2suWyU7i9dV4hHjSAuWYOpL4M=;
        b=J7GQch4y6vkerbkP/HXrrw+ORoIm/v0i0XGaK3ovReNgq/x7BtSvRKuYhYAEwDmHrT
         aqGS6S9T5ygF4y01s2fmaYKDuvT1AzmO+Zitw7ZvV3T1duL1AXJS7Fja8SfJ2BD0sFMD
         8MJjgARzQezEDUL8EbEMjOOfmDQFL9DA5pO87lEdk1BdrUekziLvNUmeeyRQor9f5hj5
         o3qRSuK8TUCjDgq04pzUHbCtSPbLn3Ys+gH8dC5jn7asBBF/mLQYBb8CYFrUg0RPd+4t
         Py4O247+QZ0yaKw8m5yQb7XHRfmX4bsR58QhgjIhABJ+2GckFy7k5z0TGojiaFCfHg1G
         6QFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741093550; x=1741698350;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8N2txbd/9bq4xEXbck2suWyU7i9dV4hHjSAuWYOpL4M=;
        b=Q2YWhxj/eIpSk62jm1YPDCGZSFFaQORDxwosQXs20jIlGVMsnknpKNew4kI+qUjtpT
         48MCy4btjDJ+GDf66Qwd/JfRgSi+8uqEXmHE3/SxEVpM1KLU12yEZCrIrrgTSPBsQLve
         W8jajEMe2a+ixuUvWA+i0Naaq+9kPrZs5OP0wVldWityJsE7AYSjG6ILynpmxZKIL857
         EPHhVUZzEl1S7s95/6Vpils50d1ZxWiELtMUGx5ph13VG2MJluvIPe37ltQ8yloVXW6F
         r+YpiZGc2CBW08nituaZA7ukOt1Cp4tpRyQJY/UcDzhbbxTyspMqUIx3kVUDJMQwTLV1
         QVLA==
X-Gm-Message-State: AOJu0YxKvykNZdCIprSE35buFlcAXqnmft7+Z8zCwx438jG9bzDg/Wzm
	FKXrzDeN7xNUHABIS38UqIh3adVWnrzSC0qZY3y34QYZ8U1snlxvYyB06jLhDYY=
X-Gm-Gg: ASbGncvx165khxM1JltBCIgvegoIPWE4/XgDMkYymHbWuiXRYa+qs1fEPXgjwP+AYKi
	LaGaL3xYkTC8BApvTcdzae1nKegBHX3BVhMMDLoI7V4KNKB+qEYPX+7GgYz0SQtgzCVC7i3V+kt
	0gXTiXpScxY+F+O1pDsMDRZnQ+J6eP0Wgve5n+t1eUqUN2MP0axmzxfxXAG55f1DzAoz6nTbaKC
	ph5Vq27wMDhfI9uXi3O21TYC78YoKaWt2oueUoNYlF78elMHtICOD26IlerH8z6fKUDEh0cQ6mo
	BQIs4BBA4JXPG+xSmr8rDTOuC4vaz7xbaLsxwjL9ryGHRe2rsQ==
X-Google-Smtp-Source: AGHT+IEN5ge4m0maHYmmWQfuN3qcxEbssYh+CrBBMtTal3JjWRd1G2wDVrbWIhbmkwSCnpOhFqrj9A==
X-Received: by 2002:a05:6000:1f82:b0:390:f45e:c851 with SMTP id ffacd0b85a97d-390f45ecb7cmr15148627f8f.21.1741093549754;
        Tue, 04 Mar 2025 05:05:49 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-390e47a66c9sm17809174f8f.33.2025.03.04.05.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 05:05:49 -0800 (PST)
Date: Tue, 4 Mar 2025 16:05:45 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-sgx@vger.kernel.org
Subject: [bug report] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
Message-ID: <c87e01a0-e7dd-4749-a348-0980d3444f04@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Jarkko Sakkinen,

Commit 888d24911787 ("x86/sgx: Add SGX_IOC_ENCLAVE_CREATE") from Nov
13, 2020 (linux-next), leads to the following Smatch static checker
warning:

	arch/x86/kernel/cpu/sgx/ioctl.c:75 sgx_encl_create()
	warn: potential user controlled sizeof overflow 'secs->size + ((1) << 12)' '0-u64max + 4096'

arch/x86/kernel/cpu/sgx/ioctl.c
    57 static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
    58 {
    59         struct sgx_epc_page *secs_epc;
    60         struct sgx_va_page *va_page;
    61         struct sgx_pageinfo pginfo;
    62         struct sgx_secinfo secinfo;
    63         unsigned long encl_size;
    64         struct file *backing;
    65         long ret;
    66 
    67         va_page = sgx_encl_grow(encl, true);
    68         if (IS_ERR(va_page))
    69                 return PTR_ERR(va_page);
    70         else if (va_page)
    71                 list_add(&va_page->list, &encl->va_pages);
    72         /* else the tail page of the VA page list had free slots. */
    73 
    74         /* The extra page goes to SECS. */
--> 75         encl_size = secs->size + PAGE_SIZE;

secs->size is a u64 that comes from the user in sgx_ioc_enclave_create().
If we add PAGE_SIZE that could be an integer overflow.  Also encl_size is
unsigned long so on 32 bits that's another integer overflow.

    76 
    77         backing = shmem_file_setup("SGX backing", encl_size + (encl_size >> 5),
                                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Also this can integer overflow.

    78                                    VM_NORESERVE);
    79         if (IS_ERR(backing)) {
    80                 ret = PTR_ERR(backing);
    81                 goto err_out_shrink;
    82         }
    83 
    84         encl->backing = backing;
    85 
    86         secs_epc = sgx_alloc_epc_page(&encl->secs, true);
    87         if (IS_ERR(secs_epc)) {
    88                 ret = PTR_ERR(secs_epc);
    89                 goto err_out_backing;
    90         }
    91 
    92         encl->secs.epc_page = secs_epc;
    93 
    94         pginfo.addr = 0;
    95         pginfo.contents = (unsigned long)secs;
    96         pginfo.metadata = (unsigned long)&secinfo;
    97         pginfo.secs = 0;
    98         memset(&secinfo, 0, sizeof(secinfo));
    99 
    100         ret = __ecreate((void *)&pginfo, sgx_get_epc_virt_addr(secs_epc));
    101         if (ret) {
    102                 ret = -EIO;
    103                 goto err_out;
    104         }
    105 
    106         if (secs->attributes & SGX_ATTR_DEBUG)
    107                 set_bit(SGX_ENCL_DEBUG, &encl->flags);
    108 
    109         encl->secs.encl = encl;
    110         encl->secs.type = SGX_PAGE_TYPE_SECS;
    111         encl->base = secs->base;
    112         encl->size = secs->size;
                ^^^^^^^^^^^^^^^^^^^^^^^
Then we re-use secs->size here.  I haven't followed this code through to
see if anything bad happens, but it makes me itch just looking at it.  :P

    113         encl->attributes = secs->attributes;
    114         encl->attributes_mask = SGX_ATTR_UNPRIV_MASK;
    115 
    116         /* Set only after completion, as encl->lock has not been taken. */
    117         set_bit(SGX_ENCL_CREATED, &encl->flags);
    118 
    119         return 0;
    120 
    121 err_out:
    122         sgx_encl_free_epc_page(encl->secs.epc_page);
    123         encl->secs.epc_page = NULL;
    124 
    125 err_out_backing:
    126         fput(encl->backing);
    127         encl->backing = NULL;
    128 
    129 err_out_shrink:
    130         sgx_encl_shrink(encl, va_page);
    131 
    132         return ret;
    133 }

regards,
dan carpenter
