Return-Path: <SRS0=NfKM=7S=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E78C433DF
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Jun 2020 20:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0C2A206FA
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Jun 2020 20:11:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BelaSpRp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgFEUK6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 5 Jun 2020 16:10:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50298 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbgFEUK6 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 5 Jun 2020 16:10:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055K8Uvm102204;
        Fri, 5 Jun 2020 20:10:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : references : date : in-reply-to : message-id : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GI8Ptl135xW+Zk5tzFEp3ceNHywpyZ3l7g6uOU+l5es=;
 b=BelaSpRpECrj5VOvxeqSW8wgJJ+tgTG8pyfmF3+K54tGlOu/IZhxch8iHoW1Gyxzi3Of
 D5rncPOAgwsy8o2jeEBxGUqRWIKk4g04n+Y1QtMFifkYUpJFGaC2qL9sOBXQGnLGQpwF
 mpQJ0XxYHvJaFbC6/E1va5LwXBcyVAKzIOE21gwA0+F6xMbFdE1xT9kuHE86CCAHj/W/
 97EXj12QPoAG+v7VyJOCuuONvO4TZBMbSigVp1tfZ8PY7aBU9eRklvTnbtObBjt2mKvm
 tuW7kYVLl8+empWOeaKZsi2L76wUxpUh93fz9Z7lxyHLTWHFBCQp3gjFphOuzPAOJrHy Tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31f9264hcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 05 Jun 2020 20:10:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055K3T7t119678;
        Fri, 5 Jun 2020 20:10:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31f92t7jk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jun 2020 20:10:22 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 055KAFd5020835;
        Fri, 5 Jun 2020 20:10:15 GMT
Received: from starbug-mbp.localdomain (/79.97.215.145)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jun 2020 20:10:14 +0000
Received: by starbug-mbp.localdomain (Postfix, from userid 501)
        id A53EF59D8EE; Fri,  5 Jun 2020 21:10:04 +0100 (IST)
From:   Darren Kenny <darren.kenny@oracle.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com
Subject: Re: [PATCH v32 12/21] x86/sgx: Add provisioning
References: <20200601075218.65618-1-jarkko.sakkinen@linux.intel.com>
        <20200601075218.65618-13-jarkko.sakkinen@linux.intel.com>
Date:   Fri, 05 Jun 2020 21:09:49 +0100
In-Reply-To: <20200601075218.65618-13-jarkko.sakkinen@linux.intel.com> (Jarkko
        Sakkinen's message of "Mon, 1 Jun 2020 10:52:09 +0300")
Message-ID: <m2img5tgtu.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (darwin)
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9643 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006050148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9643 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 cotscore=-2147483648 bulkscore=0 clxscore=1011
 impostorscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006050148
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


Hi Jarkko,

Just a couple of nits below...

On Monday, 2020-06-01 at 10:52:09 +03, Jarkko Sakkinen wrote:
> In order to provide a mechanism for devilering provisoning rights:

TYPO: s/devilering/delivering/?

>
> 1. Add a new device file /dev/sgx/provision that works as a token for
>    allowing an enclave to have the provisioning privileges.
> 2. Add a new ioctl called SGX_IOC_ENCLAVE_SET_ATTRIBUTE that accepts th=
e
>    following data structure:
>
>    struct sgx_enclave_set_attribute {
>            __u64 addr;
>            __u64 attribute_fd;
>    };
>
> A daemon could sit on top of /dev/sgx/provision and send a file
> descriptor of this file to a process that needs to be able to provision
> enclaves.
>
> The way this API is used is straight-forward. Lets assume that dev_fd i=
s
> a handle to /dev/sgx/enclave and prov_fd is a handle to
> /dev/sgx/provision.  You would allow SGX_IOC_ENCLAVE_CREATE to
> initialize an enclave with the PROVISIONKEY attribute by
>
> params.addr =3D <enclave address>;
> params.token_fd =3D prov_fd;
>
> ioctl(dev_fd, SGX_IOC_ENCLAVE_SET_ATTRIBUTE, &params);
>
> Cc: linux-security-module@vger.kernel.org
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Suggested-by: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/include/uapi/asm/sgx.h  | 11 ++++++++
>  arch/x86/kernel/cpu/sgx/driver.c | 14 ++++++++++
>  arch/x86/kernel/cpu/sgx/driver.h |  2 ++
>  arch/x86/kernel/cpu/sgx/ioctl.c  | 47 ++++++++++++++++++++++++++++++++
>  4 files changed, 74 insertions(+)
>
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/as=
m/sgx.h
> index 5edb08ab8fd0..57d0d30c79b3 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -25,6 +25,8 @@ enum sgx_page_flags {
>  	_IOWR(SGX_MAGIC, 0x01, struct sgx_enclave_add_pages)
>  #define SGX_IOC_ENCLAVE_INIT \
>  	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
> +#define SGX_IOC_ENCLAVE_SET_ATTRIBUTE \
> +	_IOW(SGX_MAGIC, 0x03, struct sgx_enclave_set_attribute)
> =20
>  /**
>   * struct sgx_enclave_create - parameter structure for the
> @@ -63,4 +65,13 @@ struct sgx_enclave_init {
>  	__u64 sigstruct;
>  };
> =20
> +/**
> + * struct sgx_enclave_set_attribute - parameter structure for the
> + *				      %SGX_IOC_ENCLAVE_SET_ATTRIBUTE ioctl
> + * @attribute_fd:	file handle of the attribute file in the securityfs
> + */
> +struct sgx_enclave_set_attribute {
> +	__u64 attribute_fd;
> +};
> +
>  #endif /* _UAPI_ASM_X86_SGX_H */
> diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx=
/driver.c
> index b4aa7b9f8376..d90114cec1c3 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -150,6 +150,13 @@ static struct miscdevice sgx_dev_enclave =3D {
>  	.fops =3D &sgx_encl_fops,
>  };
> =20
> +static struct miscdevice sgx_dev_provision =3D {
> +	.minor =3D MISC_DYNAMIC_MINOR,
> +	.name =3D "provision",
> +	.nodename =3D "sgx/provision",
> +	.fops =3D &sgx_provision_fops,
> +};
> +
>  int __init sgx_drv_init(void)
>  {
>  	unsigned int eax, ebx, ecx, edx;
> @@ -190,5 +197,12 @@ int __init sgx_drv_init(void)
>  		return ret;
>  	}
> =20
> +	ret =3D misc_register(&sgx_dev_provision);
> +	if (ret) {
> +		pr_err("Creating /dev/sgx/provision failed with %d.\n", ret);
> +		misc_deregister(&sgx_dev_enclave);
> +		return ret;
> +	}
> +
>  	return 0;
>  }
> diff --git a/arch/x86/kernel/cpu/sgx/driver.h b/arch/x86/kernel/cpu/sgx=
/driver.h
> index e4063923115b..72747d01c046 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.h
> +++ b/arch/x86/kernel/cpu/sgx/driver.h
> @@ -23,6 +23,8 @@ extern u64 sgx_attributes_reserved_mask;
>  extern u64 sgx_xfrm_reserved_mask;
>  extern u32 sgx_xsave_size_tbl[64];
> =20
> +extern const struct file_operations sgx_provision_fops;
> +
>  long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg=
);
> =20
>  int sgx_drv_init(void);
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/=
ioctl.c
> index 757cb9a4ae70..713bce437659 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -669,6 +669,50 @@ static long sgx_ioc_enclave_init(struct sgx_encl *=
encl, void __user *arg)
>  	return ret;
>  }
> =20
> +/**
> + * sgx_ioc_enclave_set_attribute - handler for %SGX_IOC_ENCLAVE_SET_AT=
TRIBUTE
> + * @filep:	open file to /dev/sgx
> + * @arg:	userspace pointer to a struct sgx_enclave_set_attribute insta=
nce
> + *
> + * Mark the enclave as being allowed to access a restricted attribute =
bit.
> + * The requested attribute is specified via the attribute_fd field in =
the
> + * provided struct sgx_enclave_set_attribute.  The attribute_fd must b=
e a
> + * handle to an SGX attribute file, e.g. =80/dev/sgx/provision".

Maybe this should be simply a double-quote rather than the Unicode left
quote?

Thanks,

Darren.

> + *
> + * Failure to explicitly request access to a restricted attribute will=
 cause
> + * sgx_ioc_enclave_init() to fail.  Currently, the only restricted att=
ribute
> + * is access to the PROVISION_KEY.
> + *
> + * Note, access to the EINITTOKEN_KEY is disallowed entirely.
> + *
> + * Return: 0 on success, -errno otherwise
> + */
> +static long sgx_ioc_enclave_set_attribute(struct sgx_encl *encl,
> +					  void __user *arg)
> +{
> +	struct sgx_enclave_set_attribute params;
> +	struct file *attribute_file;
> +	int ret;
> +
> +	if (copy_from_user(&params, arg, sizeof(params)))
> +		return -EFAULT;
> +
> +	attribute_file =3D fget(params.attribute_fd);
> +	if (!attribute_file)
> +		return -EINVAL;
> +
> +	if (attribute_file->f_op !=3D &sgx_provision_fops) {
> +		ret =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	encl->allowed_attributes |=3D SGX_ATTR_PROVISIONKEY;
> +	ret =3D 0;
> +
> +out:
> +	fput(attribute_file);
> +	return ret;
> +}
> =20
>  long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg=
)
>  {
> @@ -694,6 +738,9 @@ long sgx_ioctl(struct file *filep, unsigned int cmd=
, unsigned long arg)
>  	case SGX_IOC_ENCLAVE_INIT:
>  		ret =3D sgx_ioc_enclave_init(encl, (void __user *)arg);
>  		break;
> +	case SGX_IOC_ENCLAVE_SET_ATTRIBUTE:
> +		ret =3D sgx_ioc_enclave_set_attribute(encl, (void __user *)arg);
> +		break;
>  	default:
>  		ret =3D -ENOIOCTLCMD;
>  		break;
